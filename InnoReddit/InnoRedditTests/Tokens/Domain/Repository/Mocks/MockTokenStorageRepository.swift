//
//  MockTokenStorageRepository.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.11.25.
//

@testable import InnoReddit

final class MockTokenStorageRepository: TokenStorageRepositoryProtocol {
    var needToSucceed: Bool = true
    
    var accessToken: String?
    var refreshToken: String?
    
    func getToken(tokenType: TokenType) throws(TokenStorageError) -> String {
        if tokenType == .accessToken {
            return self.accessToken ?? ""
        } else {
            return self.refreshToken ?? ""
        }
    }
    
    func saveTokens(accessToken: String, refreshToken: String) throws(TokenStorageError) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func clearTokens() throws(TokenStorageError) {
        self.accessToken = nil
        self.refreshToken = nil
    }
}
