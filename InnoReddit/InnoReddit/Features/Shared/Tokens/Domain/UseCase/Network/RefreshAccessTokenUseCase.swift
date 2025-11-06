//
//  RefreshAccessTokenUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

protocol RefreshAccessTokenUseCaseProtocol {
    func execute(refreshToken: String) async throws
}

final class RefreshAccessTokenUseCase: RefreshAccessTokenUseCaseProtocol {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    @Injected(\.saveTokensUseCase) private var saveTokensUseCase: SaveTokensUseCaseProtocol
    
    func execute(refreshToken: String) async throws {
        let refreshedTokenRetrieval = try await self.tokenRepository.refreshAccessToken(refreshToken: refreshToken)
        try self.saveTokensUseCase.execute(accessToken: refreshedTokenRetrieval.accessToken, refreshToken: refreshToken)
    }
}
