//
//  DeleteTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

// MARK: Shouldn't be used directly as it would violate token consistency flow - use InvalidateTokensUseCase instead
/// InvalidateTokensUseCase invalidates tokens at the API level first, then deletes them from the storage using this use case
final class DeleteTokensUseCase {
    @Injected(\.tokenStorageRepository) private var tokenStorageRepository: TokenStorageRepositoryProtocol
    
    func execute() throws {
        try self.tokenStorageRepository.clearTokens()
    }
}
