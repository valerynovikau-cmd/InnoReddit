//
//  InvalidateTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

protocol InvalidateTokensUseCaseProtocol {
    func execute() async throws
}

final class InvalidateTokensUseCase: InvalidateTokensUseCaseProtocol {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    @Injected(\.deleteTokensUseCase) private var deleteTokensUseCase: DeleteTokensUseCaseProtocol
    @Injected(\.getAccessTokenUseCase) private var getAccessTokenUseCase: GetAccessTokenUseCaseProtocol
    @Injected(\.getRefreshTokenUseCase) private var getRefreshTokenUseCase: GetRefreshTokenUseCaseProtocol
    
    func execute() async throws {
        let accessToken = try self.getAccessTokenUseCase.execute()
        let refreshToken = try self.getRefreshTokenUseCase.execute()
        try await self.tokenRepository.invalidateTokens(tokenToRevoke: accessToken, tokenAccessType: .accessToken)
        try await self.tokenRepository.invalidateTokens(tokenToRevoke: refreshToken, tokenAccessType: .refreshToken)
        try self.deleteTokensUseCase.execute()
    }
}
