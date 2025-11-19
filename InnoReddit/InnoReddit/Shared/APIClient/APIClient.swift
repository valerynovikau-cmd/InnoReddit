//
//  APIClient.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 10.11.25.
//

import Foundation

enum APIError: Error {
    case networkError(statusCode: Int)
    case APIErrorMessage(message: String)
    case invalidResponse
    case invalidRequest
    case parsingError(Error)
    case unknown
}

protocol APIClient: AnyObject {
    var baseURL: URL { get }
    
    func send(request: URLRequest) async throws -> APIResponse
    
    func onTokenRefreshed(response: TokenRetrievalDTO) throws
    
    func defaultHeaders(additionalHeaders: [String: String]) throws -> [String: String]
    
    func getRefreshToken() throws -> String
}

extension APIClient {
    func sendRequest<T: Decodable>(
        path: String,
        httpMethod: HTTPMethod,
        queryParams: [String: String]? = nil,
        body: Encodable? = nil,
        additionalHeaders: [String: String] = [:]
    ) async throws -> T {
        
        var response: APIResponse?
        for _ in 0...2 {
            
            let request = try self.buildRequest(
                path: path,
                method: httpMethod,
                queryParams: queryParams,
                body: body,
                additionalHeaders: additionalHeaders
            )
            
            response = try? await self.send(request: request)
            
            if response?.statusCode == 401 {
                guard let refreshRequest = try? self.buildRefreshTokenRequest(refreshToken: self.getRefreshToken()) else {
                    throw APIError.invalidRequest
                }
                
                let refreshResponse = try? await self.send(request: refreshRequest)
                guard
                    let refreshResponse,
                    (200...299).contains(refreshResponse.statusCode)
                else {
                    throw APIError.networkError(statusCode: refreshResponse?.statusCode ?? 400)
                }
                
                let decodedRefreshResponse: TokenRetrievalDTO
                do {
                    decodedRefreshResponse = try self.decodeData(response: refreshResponse)
                } catch {
                    throw APIError.parsingError(error)
                }
                
                do {
                    try self.onTokenRefreshed(response: decodedRefreshResponse)
                } catch {
                    throw APIError.APIErrorMessage(message: "Failed to handle refresh_token")
                }
                continue
            }
            break
        }
        
        guard
            let response,
            (200...299).contains(response.statusCode)
        else {
            throw APIError.networkError(statusCode: response?.statusCode ?? 400)
        }
        
        let decodedResponse: T
        do {
             decodedResponse = try self.decodeData(response: response)
        } catch {
            throw APIError.parsingError(error)
        }
        return decodedResponse
    }
    
    private func buildRefreshTokenRequest(refreshToken: String) throws -> URLRequest {
        let path = "/api/v1/access_token"
        let body = RefreshTokenDTO(grantType: "refresh_token", refreshToken: refreshToken)
        return try self.buildRequest(
            path: path,
            method: HTTPMethod.POST,
            queryParams: nil,
            body: body,
            additionalHeaders: [:]
        )
    }
    
    private func buildRequest(
        path: String,
        method: HTTPMethod,
        queryParams: [String: String]? = nil,
        body: Encodable? = nil,
        additionalHeaders: [String: String] = [:]
    ) throws -> URLRequest {
        guard var urlComponents = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidRequest
        }
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            throw APIError.invalidRequest
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var headers: [String: String] = [:]
        do {
            headers = try self.defaultHeaders(additionalHeaders: additionalHeaders)
        } catch {
            throw APIError.invalidRequest
        }
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body {
            guard let encodedBody = try? JSONEncoder().encode(body) else {
                throw APIError.invalidRequest
            }
            request.httpBody = encodedBody
        }
        return request
    }
    
    private func decodeData<T: Decodable>(response: APIResponse) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: response.data)
    }
}
