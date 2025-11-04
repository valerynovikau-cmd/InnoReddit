//
//  TokenRepository.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class TokenRepository: TokenRepositoryProtocol {
    @Injected(\.redditOAuthAPISource) private var redditOAuthAPISource: RedditOAuthAPISource
    
    func exchangeCodeForTokens(code: String) async throws(TokenError) -> TokenRetrieval {
        do {
            let tokenRetrieval = try await redditOAuthAPISource.performTokenRetrieval(code: code)
            let scopes = self.convertScopesString(scopesString: tokenRetrieval.scope)
            return TokenRetrieval(
                accessToken: tokenRetrieval.accessToken,
                tokenType: tokenRetrieval.tokenType,
                expiresIn: tokenRetrieval.expiresIn,
                scope: scopes,
                refreshToken: tokenRetrieval.refreshToken
            )
        } catch {
            switch error {
            case .codeHasExpired, .invalidClientData, .invalidCredentials, .invalidURL, .noCodeWasIncluded, .noRefreshTokenWasIncluded, .unsupportedGrantType:
                throw .invalidRequest
            case .invalidData, .invalidResponse:
                throw .invalidResponse
            default:
                throw .unknownError
            }
        }
    }
    
    func refreshAccessToken(refreshToken: String) async throws(TokenError) -> TokenRetrieval {
        do {
            let refreshedTokenResponse = try await redditOAuthAPISource.performAccessTokenRefresh(refreshToken: refreshToken)
            let scopes = self.convertScopesString(scopesString: refreshedTokenResponse.scope)
            var newRefreshToken = refreshedTokenResponse.refreshToken
            if newRefreshToken == nil {
                newRefreshToken = refreshToken
            }
            return TokenRetrieval(
                accessToken: refreshedTokenResponse.accessToken,
                tokenType: refreshedTokenResponse.tokenType,
                expiresIn: refreshedTokenResponse.expiresIn,
                scope: scopes,
                refreshToken: newRefreshToken
            )
        } catch {
            switch error {
            default:
                switch error {
                case .codeHasExpired, .invalidClientData, .invalidCredentials, .invalidURL, .noCodeWasIncluded, .noRefreshTokenWasIncluded, .unsupportedGrantType:
                    throw .invalidRequest
                case .invalidData, .invalidResponse:
                    throw .invalidResponse
                default:
                    throw .unknownError
                }
            }
        }
    }
    
    func invalidateTokens() async throws(TokenError) {
        fatalError()
    }
    
    private func convertScopesString(scopesString: String) -> [AuthScopes] {
        return scopesString
            .split(separator: " ")
            .compactMap { AuthScopes.init(rawValue: String($0)) }
    }
}
