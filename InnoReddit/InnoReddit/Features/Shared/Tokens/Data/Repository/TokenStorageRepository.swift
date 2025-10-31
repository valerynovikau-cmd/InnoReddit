//
//  TokenStorageRepository.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class TokenStorageRepository: TokenStorageRepositoryProtocol {
    @Injected(\.keychainDataSource) private var keychainDataSource: KeychainDataSource
    
    func getTokens() -> (accessToken: String, refreshToken: String)? {
        <#code#>
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        <#code#>
    }
    
    func clearTokens() {
        <#code#>
    }
}
