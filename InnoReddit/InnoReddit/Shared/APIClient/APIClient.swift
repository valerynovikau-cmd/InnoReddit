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
    case parsingError(Error)
    case unknown
}

protocol APIClient: AnyObject {
    var baseURL: URL { get }
    
    func send(request: URLRequest) async throws -> APIResponse
    
    func onTokenRefreshed(response: APIResponse)
    
    var defaultHeaders: ((_ additionalHeaders: [String: String]) -> [String: String])? { get }
    
    func getRefreshToken() -> String
}

extension APIClient {
    func sendRequest<T: Decodable>(
        path: String,
        httpMethod: HTTPMethod,
        queryParams: [String: String]? = nil,
        body: Encodable? = nil,
        additionalHeaders: [String: String] = [:]
    ) async throws -> T {
        
        var response: APIResponse!
        for _ in 0...2 {
            
            let request = try self.buildRequest(
                path: path,
                method: httpMethod,
                queryParams: queryParams,
                body: body,
                additionalHeaders: additionalHeaders
            )
            
            response = try await self.send(request: request)
            if response.statusCode == 401 {
                let refreshRequest = try self.buildRefreshTokenRequest(refreshToken: self.getRefreshToken())
                let refreshResponse = try await self.send(request: refreshRequest)
                self.onTokenRefreshed(response: refreshResponse)
                continue
            }
            break
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw APIError.networkError(statusCode: response.statusCode)
        }
        return try self.decodeData(response: response)
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
            throw APIError.invalidResponse
        }
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            throw APIError.invalidResponse
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        if let headers = self.defaultHeaders?(additionalHeaders) {
            request.allHTTPHeaderFields = headers
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        return request
    }
    
    private func decodeData<T: Decodable>(response: APIResponse) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: response.data)
    }
}
