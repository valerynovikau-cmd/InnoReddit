//
//  DeleteTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class DeleteTokensUseCase {
    @Injected(\.tokenStorageRepository) private var tokenStorageRepository: TokenStorageRepositoryProtocol
    
    func execute() throws {
        try self.tokenStorageRepository.clearTokens()
    }
}
