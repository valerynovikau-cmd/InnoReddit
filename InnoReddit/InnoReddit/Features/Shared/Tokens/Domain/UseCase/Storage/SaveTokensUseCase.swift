//
//  SaveTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

protocol SaveTokensUseCaseProtocol {
    func execute(accessToken: String, refreshToken: String) throws
}

// MARK: Shouldn't be used directly as it would violate token consistency flow - use RetrieveTokensUseCase and RefreshAccessTokenUseCase instead
/// RetrieveTokensUseCase retrieves tokens from the API, then saves them to the storage using this use case
/// RefreshAccessTokenUseCase updates access token from the API, then saves tokens to the storage using this use case
final class SaveTokensUseCase: SaveTokensUseCaseProtocol {
    @Injected(\.tokenStorageRepository) private var tokenStorageRepository: TokenStorageRepositoryProtocol
    
    func execute(accessToken: String, refreshToken: String) throws {
        try self.tokenStorageRepository.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
    }
}
