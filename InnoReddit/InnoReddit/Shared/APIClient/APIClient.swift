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
        jsonBody: Encodable? = nil,
        urlEncodedBody: [String: String]? = nil,
        additionalHeaders: [String: String] = [:],
        differentBaseURL: URL? = nil
    ) async throws(APIError) -> T {
        
        var response: APIResponse?
        for _ in 0...2 {
            
            let request = try self.buildRequest(
                path: path,
                method: httpMethod,
                queryParams: queryParams,
                jsonBody: jsonBody,
                urlEncodedBody: urlEncodedBody,
                additionalHeaders: additionalHeaders,
                differentBaseURL: differentBaseURL
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
    
    private func buildRefreshTokenRequest(refreshToken: String) throws(APIError) -> URLRequest {
        let baseURL = URL(string: "https://www.reddit.com")!
        let path = "/api/v1/access_token"
        
        let body: [String: String] = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        guard let clientId = Bundle.main.infoDictionary?["ClientID"] as? String else {
            throw APIError.invalidRequest
        }
        
        let credentials = "\(clientId):"
        let encoded = Data(credentials.utf8).base64EncodedString()
        
        let additionalHeaders: [String:String] = [
            "Authorization": "Basic \(encoded)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        return try self.buildRequest(
            path: path,
            method: HTTPMethod.POST,
            queryParams: nil,
            urlEncodedBody: body,
            additionalHeaders: additionalHeaders,
            differentBaseURL: baseURL
        )
    }
    
    private func buildRequest(
        path: String,
        method: HTTPMethod,
        queryParams: [String: String]? = nil,
        jsonBody: Encodable? = nil,
        urlEncodedBody: [String: String]? = nil,
        additionalHeaders: [String: String] = [:],
        differentBaseURL: URL? = nil
    ) throws(APIError) -> URLRequest {
        guard (urlEncodedBody == nil && jsonBody == nil) ||
              (urlEncodedBody == nil && jsonBody != nil) ||
              (urlEncodedBody != nil && jsonBody == nil)
        else {
            throw APIError.invalidRequest
        }
        
        var url: URL!
        if let differentBaseURL {
            url = differentBaseURL.appendingPathComponent(path)
        } else {
            url = self.baseURL.appendingPathComponent(path)
        }
        
        guard var urlComponents = URLComponents(
            url: url,
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
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let jsonBody {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try? encoder.encode(jsonBody)
        }
        if let urlEncodedBody {
            var components = URLComponents()
            components.queryItems = urlEncodedBody.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.httpBody = components.query?.data(using: .utf8)
        }
        
        return request
    }
    
    private func decodeData<T: Decodable>(response: APIResponse) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: response.data)
    }
}
