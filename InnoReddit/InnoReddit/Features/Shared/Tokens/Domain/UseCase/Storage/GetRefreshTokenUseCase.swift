//
//  GetRefreshTokenUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

protocol GetRefreshTokenUseCaseProtocol {
    func execute() throws -> String
}

final class GetRefreshTokenUseCase: GetRefreshTokenUseCaseProtocol {
    @Injected(\.tokenStorageRepository) private var tokenStorageRepository: TokenStorageRepositoryProtocol
    
    func execute() throws -> String {
        let token = try self.tokenStorageRepository.getToken(tokenType: .refreshToken)
        return token
    }
}
