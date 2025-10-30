//
//  ASWebAuthSessionService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import AuthenticationServices

fileprivate enum AuthScopes: String {
    case identity, edit, flair, history, modconfig, modflair, modlog, modposts, modwiki, mysubreddits, privatemessages, read, report, save, submit, subscribe, vote, wikiedit, wikiread
}

fileprivate enum TokenDuration: String {
    case permanent, temporary
}

protocol ASWebAuthSessionServiceProtocol {
    func startSession() async throws -> URL
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
        
        var comp = self.components
        comp.path = "/api/v1/authorize.compact"
        comp.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "duration", value: "temporary"),
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
    func startSession() async throws -> URL {
        let scopes: [AuthScopes] = [
            .read,
            .identity
        ]
        
        let authURL = try self.assembleAuthURL(scope: scopes, duration: .temporary)
        let callbackScheme = try self.redirectURLScheme
        
        return try await withCheckedThrowingContinuation { continuation in
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
    }
}

extension ASWebAuthSessionService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first ?? UIWindow()
    }
}
