//
//  InvalidateTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class InvalidateTokensUseCase {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    @Injected(\.deleteTokensUseCase) private var deleteTokensUseCase: DeleteTokensUseCase
    
    func execute() async throws {
        try await self.tokenRepository.invalidateTokens()
        try self.deleteTokensUseCase.execute()
    }
}
