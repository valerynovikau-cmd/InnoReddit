//
//  RetrieveTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class RetrieveTokensUseCase {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    @Injected(\.saveTokensUseCase) private var saveTokensUseCase: SaveTokensUseCase
    
    func execute(code: String) async throws {
        let tokenRetrieval = try await self.tokenRepository.exchangeCodeForTokens(code: code)
        guard let refreshToken = tokenRetrieval.refreshToken else {
            throw TokenError.invalidResponse
        }
        try saveTokensUseCase.execute(accessToken: tokenRetrieval.accessToken, refreshToken: refreshToken)
    }
}
