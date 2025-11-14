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
    case invalidRequestData
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
    ) async throws -> T {
        
        var response: APIResponse!
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
            
            response = try await self.send(request: request)
            if response.statusCode == 401 {
                let refreshRequest = try self.buildRefreshTokenRequest(refreshToken: self.getRefreshToken())
                let refreshResponse = try await self.send(request: refreshRequest)
                do {
                    let decodedRefreshResponse: TokenRetrievalDTO = try self.decodeData(response: refreshResponse)
                    try self.onTokenRefreshed(response: decodedRefreshResponse)
                } catch {
                    print(error)
                }
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
        let baseURL = URL(string: "https://www.reddit.com")!
        let path = "/api/v1/access_token"
        
        let body: [String: String] = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        guard let clientId = Bundle.main.infoDictionary?["ClientID"] as? String else {
            throw APIError.invalidRequestData
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
    ) throws -> URLRequest {
        guard (urlEncodedBody == nil && jsonBody == nil) ||
              (urlEncodedBody == nil && jsonBody != nil) ||
              (urlEncodedBody != nil && jsonBody == nil)
        else {
            throw APIError.invalidRequestData
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
            throw APIError.invalidRequestData
        }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            throw APIError.invalidRequestData
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let headers = try self.defaultHeaders(additionalHeaders: additionalHeaders)
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
