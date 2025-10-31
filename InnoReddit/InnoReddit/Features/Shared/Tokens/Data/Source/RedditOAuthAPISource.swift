//
//  RedditOAuthAPISource.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Foundation

final class RedditOAuthAPISource {
    
    private var components: URLComponents {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "www.reddit.com"
        return comp
    }
    
    private var clientID: String {
        get throws {
            guard let id = Bundle.main.infoDictionary?["ClientID"] as? String else {
                throw URLError(.badURL)
            }
            return id
        }
    }
    
    private var redirectURLScheme: String {
        get throws {
            guard let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]],
                  let urlSchemes = urlTypes.first?["CFBundleURLSchemes"] as? [String],
                  let callbackScheme = urlSchemes.first
            else {
                throw URLError(.badURL)
            }
            return callbackScheme
        }
    }
    
    func performTokenRetrieval(code: String) async throws -> TokenRetrievalDTO {
        var comp = self.components
        comp.path = "/api/v1/access_token"
        
        guard let url = comp.url else {
            throw URLError(.badURL)
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

        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let tokenRetrievalDTO = try decoder.decode(TokenRetrievalDTO.self, from: data)
        
        return tokenRetrievalDTO
    }
}
