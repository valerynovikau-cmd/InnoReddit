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
    
    func execute() async throws {
        try await self.tokenRepository.invalidateTokens()
        try self.deleteTokensUseCase.execute()
    }
}
