//
//  GetAccessTokenUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class GetAccessTokenUseCase {
    @Injected(\.retrieveTokensUseCase) private var retrieveTokensUseCase: RetrieveTokensUseCase
    @Injected(\.refreshAccessTokenUseCase) private var refreshAccessTokenUseCase: RefreshAccessTokenUseCase
    @Injected(\.tokenStorageRepository) private var tokenStorageRepository: TokenStorageRepositoryProtocol
    
    func execute() async throws {
        
    }
}
