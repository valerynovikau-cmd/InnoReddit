//
//  SaveTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class SaveTokensUseCase {
    @Injected(\.tokenStorageRepository) private var tokenStorageRepository: TokenStorageRepositoryProtocol
    
    func execute(accessToken: String, refreshToken: String) throws {
        try self.tokenStorageRepository.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
    }
}
