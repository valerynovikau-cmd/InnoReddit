//
//  RetrieveTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

protocol RetrieveTokensUseCaseProtocol {
    func execute(code: String, scopes: [AuthScopes]) async throws
}

final class RetrieveTokensUseCase: RetrieveTokensUseCaseProtocol {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    @Injected(\.saveTokensUseCase) private var saveTokensUseCase: SaveTokensUseCaseProtocol
    
    func execute(code: String, scopes: [AuthScopes]) async throws {
        let tokenRetrieval = try await self.tokenRepository.exchangeCodeForTokens(code: code)
        let retrievedScopes = tokenRetrieval.scope
        guard
            let refreshToken = tokenRetrieval.refreshToken,
            scopes == retrievedScopes
        else {
            throw TokenError.invalidResponse
        }
        try saveTokensUseCase.execute(accessToken: tokenRetrieval.accessToken, refreshToken: refreshToken)
    }
}
