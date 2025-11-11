//
//  RedditOAuthAPISource.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Foundation

enum RedditOAuthFlowError: Error {
    // In-code error handling types
    case invalidURL
    case invalidClientData
    case invalidResponse
    case invalidData
    
    // API Errors
    case invalidCredentials
    case unsupportedGrantType
    case noCodeWasIncluded
    case codeHasExpired
    case noRefreshTokenWasIncluded
}

final class RedditOAuthAPISource {
    
    // MARK: - Authentication URL assembly methods
    private var components: URLComponents {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "www.reddit.com"
        return comp
    }
    
    private var clientID: String {
        get throws(RedditOAuthFlowError) {
            guard let id = Bundle.main.infoDictionary?["ClientID"] as? String else {
                throw .invalidClientData
            }
            return id
        }
    }
    
    private var redirectURLScheme: String {
        get throws(RedditOAuthFlowError) {
            guard let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]],
                  let urlSchemes = urlTypes.first?["CFBundleURLSchemes"] as? [String],
                  let callbackScheme = urlSchemes.first
            else {
                throw .invalidClientData
            }
            return callbackScheme
        }
    }
    
    // MARK: - API Request methods
    func performTokenRetrieval(code: String) async throws(RedditOAuthFlowError) -> TokenRetrievalDTO {
        var comp = self.components
        comp.path = "/api/v1/access_token"
        
        guard let url = comp.url else {
            throw .invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let redirectURI = try self.redirectURLScheme + "://auth"
        let body = "grant_type=authorization_code&code=\(code)&redirect_uri=\(redirectURI)"
        request.httpBody = body.data(using: .utf8)

        let clientId = try self.clientID
        let credentials = "\(clientId):"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw .invalidResponse
        }
        
        return try self.handleTokenRetrievalResponse(data: data, response: response)
    }
    
    func performAccessTokenRefresh(refreshToken: String) async throws(RedditOAuthFlowError) -> TokenRetrievalDTO {
        var comp = self.components
        comp.path = "/api/v1/access_token"
        
        guard let url = comp.url else {
            throw .invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "grant_type=refresh_token&refresh_token=\(refreshToken)"
        request.httpBody = body.data(using: .utf8)

        let clientId = try self.clientID
        let credentials = "\(clientId):"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw .invalidResponse
        }
        
        return try self.handleTokenRetrievalResponse(data: data, response: response)
    }
    
    func performTokenRevoking(tokenToRevoke: String, tokenAccessType: TokenAccessType) async throws(RedditOAuthFlowError) {
        var comp = self.components
        comp.path = "/api/v1/revoke_token"
        
        guard let url = comp.url else {
            throw .invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "token=\(tokenToRevoke)&token_type_hint=\(tokenAccessType.rawValue)"
        request.httpBody = body.data(using: .utf8)

        let clientId = try self.clientID
        let credentials = "\(clientId):"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        guard let (_, _) = try? await URLSession.shared.data(for: request) else {
            throw .invalidCredentials
        }
    }
    
    // Developers of Reddit OAuth API did not care enough to ensure proper error handling, so this part of error propagation may not throw exact error types but instead throw .invalidData
    private func handleTokenRetrievalResponse(data: Data, response: URLResponse) throws(RedditOAuthFlowError) -> TokenRetrievalDTO {
        if (400...499).contains((response as? HTTPURLResponse)?.statusCode ?? 0) {
            throw .invalidCredentials
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let tokenRetrievalDTO = try decoder.decode(TokenRetrievalDTO.self, from: data)
            return tokenRetrievalDTO
        } catch {
            guard let tokenRetrievalErrorDTO = try? decoder.decode(TokenRetrievalErrorDTO.self, from: data) else {
                throw .invalidData
            }
            switch tokenRetrievalErrorDTO.error {
            case "unsupported_grant_type":
                throw .unsupportedGrantType
            case "NO_TEXT for field code":
                throw .noCodeWasIncluded
            case "invalid_grant":
                throw .codeHasExpired
            case "NO_TEXT for field refresh_token":
                throw .noRefreshTokenWasIncluded
            default:
                throw .invalidData
            }
        }
    }
}
