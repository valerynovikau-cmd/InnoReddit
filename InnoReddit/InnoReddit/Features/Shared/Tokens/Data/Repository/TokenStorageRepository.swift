//
//  TokenStorageRepository.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class TokenStorageRepository: TokenStorageRepositoryProtocol {
    
    @Injected(\.keychainDataSource) private var keychainDataSource: KeychainDataSource
    
    func getToken(tokenType: TokenType) throws -> String {
        return try self.keychainDataSource.getToken(tokenType: tokenType)
    }
    
    func saveTokens(accessToken: String, refreshToken: String) throws {
        try self.keychainDataSource.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func clearTokens() throws {
        try self.keychainDataSource.deleteTokens()
    }
}
