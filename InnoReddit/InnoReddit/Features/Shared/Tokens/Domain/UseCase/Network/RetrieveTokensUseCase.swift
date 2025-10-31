//
//  RetrieveTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class RetrieveTokensUseCase {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    
    
    func execute(code: String) async throws -> TokenRetrieval {
        return try await self.tokenRepository.exchangeCodeForTokens(code: code)
    }
}
