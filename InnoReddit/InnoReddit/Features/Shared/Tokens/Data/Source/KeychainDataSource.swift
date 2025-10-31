//
//  KeychainDataSource.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Foundation
import Security

final class KeychainDataSource {
    
    enum KeychainError: Error {
        case invalidData
        case tokenNotFound
        case tokensSaveError(_ accessToken: OSStatus, _ refreshToken: OSStatus)
        case tokensDeleteError(_ accessToken: OSStatus, _ refreshToken: OSStatus)
    }
    
    func saveTokens(accessToken: String, refreshToken: String) throws {
        guard let accessTokenData = accessToken.data(using: .utf8),
              let refreshTokenData = refreshToken.data(using: .utf8)
        else {
            throw KeychainError.invalidData
        }

        let accessQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: TokenType.accessToken,
            kSecValueData as String: accessTokenData
        ] as CFDictionary
        
        let refreshQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: TokenType.refreshToken,
            kSecValueData as String: refreshTokenData
        ] as CFDictionary
        
        try self.deleteTokens()
        
        let accessStatus = SecItemAdd(accessQuery, nil)
        let refreshStatus = SecItemAdd(refreshQuery, nil)
        
        guard accessStatus == errSecSuccess,
              refreshStatus == errSecSuccess
        else {
            throw KeychainError.tokensSaveError(accessStatus, refreshStatus)
        }
    }
    
    func getToken(tokenType: TokenType) throws -> String {
        let key = tokenType.rawValue
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess else {
            throw KeychainError.tokenNotFound
        }
        
        guard let data = dataTypeRef as? Data,
              let token = String(data: data, encoding: .utf8)
        else
        {
            throw KeychainError.invalidData
        }
        return token
    }
    
    func deleteTokens() throws {
        let accessQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: TokenType.accessToken
        ] as CFDictionary
        
        let refreshQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: TokenType.refreshToken
        ] as CFDictionary
        
        let accessStatus = SecItemDelete(accessQuery)
        let refreshStatus = SecItemDelete(refreshQuery)
        guard accessStatus == errSecSuccess,
              refreshStatus == errSecSuccess
        else {
            throw KeychainError.tokensDeleteError(accessStatus, refreshStatus)
        }
    }
}
