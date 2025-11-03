//
//  RefreshAccessTokenUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class RefreshAccessTokenUseCase {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    @Injected(\.saveTokensUseCase) private var saveTokensUseCase: SaveTokensUseCase
    
    func execute(refreshToken: String) async throws {
        let refreshedTokenRetrieval = try await self.tokenRepository.refreshAccessToken(refreshToken: refreshToken)
        try self.saveTokensUseCase.execute(accessToken: refreshedTokenRetrieval.accessToken, refreshToken: refreshToken)
    }
}
