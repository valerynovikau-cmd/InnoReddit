//
//  APIClientProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 10.11.25.
//

import Foundation

protocol APIClientProtocol: AnyObject {
    var baseURL: URL { get }
    var tokensBaseURL: URL { get }
    
    func send(request: URLRequest) async throws(APIError) -> APIResponse
    
    func onTokenRefreshed(response: TokenRetrievalDTO) throws(APIError)
    
    func defaultHeaders(additionalHeaders: [String: String]) throws(APIError) -> [String: String]
    
    func getRefreshToken() throws(APIError) -> String
}

extension APIClientProtocol {
    func sendRequest<T: Decodable>(
        path: String,
        httpMethod: HTTPMethod,
        queryParams: [String: String]? = nil,
        body: RequestBody? = nil,
        additionalHeaders: [String: String] = [:],
        urlToUse: APIBaseURL = APIBaseURL.base
    ) async throws(APIError) -> T {
        
        var response: APIResponse?
        for _ in 0...2 {
            
            let request = try self.buildRequest(
                path: path,
                method: httpMethod,
                queryParams: queryParams,
                body: body,
                additionalHeaders: additionalHeaders,
                urlToUse: .base
            )
            
            response = try? await self.send(request: request)
            
            if response?.statusCode == 401 {
                guard let refreshRequest = try? self.buildRefreshTokenRequest(refreshToken: self.getRefreshToken()) else {
                    throw APIError.invalidRequest
                }
                
                let refreshResponse = try? await self.send(request: refreshRequest)
                guard let refreshResponse else {
                    throw APIError.invalidResponse
                }
                guard (200...299).contains(refreshResponse.statusCode) else {
                    throw APIError.networkError(statusCode: refreshResponse.statusCode)
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
                    throw APIError.localTokenHandlingError
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
        let path = "/api/v1/access_token"
        
        let body: [String: String] = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        guard let clientId = ConfigParameterManager.clientID else {
            throw APIError.invalidRequest
        }
        
        let credentials = "\(clientId):"
        let encoded = Data(credentials.utf8).base64EncodedString()
        
        let additionalHeaders: [String:String] = [
            "Authorization": "Basic \(encoded)"
        ]
        return try self.buildRequest(
            path: path,
            method: HTTPMethod.POST,
            queryParams: nil,
            body: RequestBody.urlEncodedBody(body),
            additionalHeaders: additionalHeaders,
            urlToUse: .tokens
        )
    }
    
    private func buildRequest(
        path: String,
        method: HTTPMethod,
        queryParams: [String: String]? = nil,
        body: RequestBody? = nil,
        additionalHeaders: [String: String] = [:],
        urlToUse: APIBaseURL
    ) throws(APIError) -> URLRequest {
        var url: URL!
        switch urlToUse {
        case .base:
            url = self.baseURL.appendingPathComponent(path)
        case .tokens:
            url = self.tokensBaseURL.appendingPathComponent(path)
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
        
        var contentType: String?
        switch body {
        case .jsonBody(let body):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try? encoder.encode(body)
            contentType = "application/json"
        case .urlEncodedBody(let body):
            var components = URLComponents()
            components.queryItems = body.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.httpBody = components.query?.data(using: .utf8)
            contentType = "application/x-www-form-urlencoded"
        case .none:
            break
        }
        
        if let contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func decodeData<T: Decodable>(response: APIResponse) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: response.data)
    }
}
