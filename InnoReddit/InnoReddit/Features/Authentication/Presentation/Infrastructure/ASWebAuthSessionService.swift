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

enum AuthenticationSessionError: Error {
    // In-code error handling types
    case invalidClientData
    case invalidURL
    case invalidResponseURL
    
    // API Errors
    case accessDenied
    case unsupportedResponseType
    case invalidScope
    case invalidRequest
    case noCodeReturned
    
    case unknownError
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
        get throws(AuthenticationSessionError) {
            guard let id = Bundle.main.infoDictionary?["ClientID"] as? String else {
                throw .invalidClientData
            }
            return id
        }
    }
    
    private var redirectURLScheme: String {
        get throws(AuthenticationSessionError) {
            guard let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]],
                  let urlSchemes = urlTypes.first?["CFBundleURLSchemes"] as? [String],
                  let callbackScheme = urlSchemes.first
            else {
                throw .invalidClientData
            }
            return callbackScheme
        }
    }
    
    private func assembleAuthURL(scope: [AuthScopes], duration: TokenDuration) throws(AuthenticationSessionError) -> URL {
        let state = UUID().uuidString
        let authScopesString = scope.map(\.rawValue).joined(separator: " ")
        
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
            URLQueryItem(name: "scope", value: authScopesString)
        ]
        
        guard let url = comp.url else {
            throw .invalidURL
        }
        
        return url
    }
}

// MARK: - Authentication Session request

extension ASWebAuthSessionService: ASWebAuthSessionServiceProtocol {
    func startSession() async throws(AuthenticationSessionError) -> String {
        let scopes: [AuthScopes] = [
            .read,
            .identity
        ]
        
        let authURL = try self.assembleAuthURL(scope: scopes, duration: .permanent)
        let callbackScheme = try self.redirectURLScheme
        
        guard
            let url = (try? await withCheckedThrowingContinuation { continuation in
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
            }),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            throw .invalidResponseURL
        }
        
        return try self.handleResponse(components: components)
    }
    
    private func handleResponse(components: URLComponents) throws(AuthenticationSessionError) -> String {
        let queryItems = components.queryItems
        if let error = queryItems?.first(where: { $0.name == "error" })?.value {
            switch error {
            case "access_denied":
                throw .accessDenied
            case "unsupported_response_type":
                throw .unsupportedResponseType
            case "invalid_scope":
                throw .invalidScope
            case "invalid_request":
                throw .invalidRequest
            default:
                throw .unknownError
            }
        }
        
        guard let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            throw .noCodeReturned
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
