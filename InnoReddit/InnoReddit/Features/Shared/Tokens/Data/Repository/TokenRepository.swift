//
//  TokenRepository.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class TokenRepository: TokenRepositoryProtocol {
    @Injected(\.redditOAuthAPISource) private var redditOAuthAPISource: RedditOAuthAPISource
    
    func exchangeCodeForTokens(code: String) async throws -> TokenRetrieval {
        let tokenRetrieval = try await redditOAuthAPISource.performTokenRetrieval(code: code)
        let scopes = tokenRetrieval.scope
            .split(separator: " ")
            .compactMap { AuthScopes.init(rawValue: String($0)) }
        return TokenRetrieval(
            accessToken: tokenRetrieval.accessToken,
            tokenType: tokenRetrieval.tokenType,
            expiresIn: tokenRetrieval.expiresIn,
            scope: scopes,
            refreshToken: tokenRetrieval.refreshToken
        )
    }
    
    func refreshAccessToken(refreshToken: String) async throws -> TokenRetrieval {
        fatalError()
    }
    
    func invalidateTokens() async throws {
        fatalError()
    }
}
