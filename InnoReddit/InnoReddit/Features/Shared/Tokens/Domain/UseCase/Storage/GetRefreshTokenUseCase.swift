//
//  GetRefreshTokenUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class GetRefreshTokenUseCase {
    @Injected(\.tokenStorageRepository) private var tokenStorageRepository: TokenStorageRepositoryProtocol
    
    func execute() throws -> String {
        let token = try self.tokenStorageRepository.getToken(tokenType: .refreshToken)
        return token
    }
}
