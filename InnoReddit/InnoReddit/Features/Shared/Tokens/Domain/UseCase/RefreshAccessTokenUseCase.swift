//
//  RefreshAccessTokenUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class RefreshAccessTokenUseCase {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepositoryProtocol
    
    func execute() {
        
    }
}
