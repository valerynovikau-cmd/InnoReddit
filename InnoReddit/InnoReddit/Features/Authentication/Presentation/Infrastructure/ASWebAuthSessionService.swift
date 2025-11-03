//
//  ASWebAuthSessionService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import AuthenticationServices

protocol ASWebAuthSessionServiceProtocol {
    func startSession() async throws -> String
}

final class ASWebAuthSessionService: NSObject {
    
    // MARK: - Authentication URL assembly methods
    
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
    
    private func assembleAuthURL(scope: [AuthScopes], duration: TokenDuration) throws -> URL {
        let state = UUID().uuidString
        let auchScopesString = scope.map(\.rawValue).joined(separator: " ")
        
        let clientID = try self.clientID
        let redirectUri = try self.redirectURLScheme + "://auth"
        let duration = duration.rawValue
        
        var comp = self.components
        comp.path = "/api/v1/authorize.compact"
        comp.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "duration", value: duration),
            URLQueryItem(name: "scope", value: auchScopesString)
        ]
        
        guard let url = comp.url else {
            throw URLError(.badURL)
        }
        
        return url
    }
}

// MARK: - Authentication Session request

extension ASWebAuthSessionService: ASWebAuthSessionServiceProtocol {
    func startSession() async throws -> String {
        let scopes: [AuthScopes] = [
            .read,
            .identity
        ]
        
        let authURL = try self.assembleAuthURL(scope: scopes, duration: .permanent)
        let callbackScheme = try self.redirectURLScheme
        
        let url = try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: callbackScheme
            ) { callbackURL, error in
                if let url = callbackURL {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: error ?? URLError(.cancelled))
                }
            }
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let code = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
            throw NSError()
        }
        
        return code
    }
}

extension ASWebAuthSessionService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first ?? UIWindow()
    }
}
