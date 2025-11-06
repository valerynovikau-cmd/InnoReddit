//
//  TokensDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

// MARK: Data sources
extension Container {
    var redditOAuthAPISource: Factory<RedditOAuthAPISource> {
        self { @MainActor in
            RedditOAuthAPISource()
        }
    }
    
    var keychainDataSource: Factory<KeychainDataSource> {
        self { @MainActor in
            KeychainDataSource()
        }
    }
}

// MARK: Repositories
extension Container {
    var tokenRepository: Factory<TokenRepositoryProtocol> {
        self { @MainActor in
            TokenRepository()
        }
    }
    
    var tokenStorageRepository: Factory<TokenStorageRepositoryProtocol> {
        self { @MainActor in
            TokenStorageRepository()
        }
    }
}

// MARK: UseCases
extension Container {
    var getAccessTokenUseCase: Factory<GetAccessTokenUseCaseProtocol> {
        self { @MainActor in
            GetAccessTokenUseCase()
        }
    }
    
    var getRefreshTokenUseCase: Factory<GetRefreshTokenUseCaseProtocol> {
        self { @MainActor in
            GetRefreshTokenUseCase()
        }
    }
    
    var invalidateTokensUseCase: Factory<InvalidateTokensUseCaseProtocol> {
        self { @MainActor in
            InvalidateTokensUseCase()
        }
    }
    
    var refreshAccessTokenUseCase: Factory<RefreshAccessTokenUseCaseProtocol> {
        self { @MainActor in
            RefreshAccessTokenUseCase()
        }
    }
    
    var retrieveTokensUseCase: Factory<RetrieveTokensUseCaseProtocol> {
        self { @MainActor in
            RetrieveTokensUseCase()
        }
    }
    
    var saveTokensUseCase: Factory<SaveTokensUseCaseProtocol> {
        self { @MainActor in
            SaveTokensUseCase()
        }
    }
    
    var deleteTokensUseCase: Factory<DeleteTokensUseCaseProtocol> {
        self { @MainActor in
            DeleteTokensUseCase()
        }
    }
}
