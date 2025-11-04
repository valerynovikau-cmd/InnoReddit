//
//  KeychainDataSource.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Foundation
import Security

enum KeychainError: Error {
    case invalidData
    case tokenNotFound
    case tokensSaveError(_ accessToken: OSStatus, _ refreshToken: OSStatus)
    case tokensDeleteError(_ accessToken: OSStatus, _ refreshToken: OSStatus)
}

final class KeychainDataSource {
    
    func saveTokens(accessToken: String, refreshToken: String) throws(KeychainError) {
        guard let accessTokenData = accessToken.data(using: .utf8),
              let refreshTokenData = refreshToken.data(using: .utf8)
        else {
            throw .invalidData
        }

        let accessQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: TokenType.accessToken.rawValue,
            kSecValueData as String: accessTokenData
        ] as CFDictionary
        
        let refreshQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: TokenType.refreshToken.rawValue,
            kSecValueData as String: refreshTokenData
        ] as CFDictionary
        
        try? self.deleteTokens()
        
        let accessStatus = SecItemAdd(accessQuery, nil)
        let refreshStatus = SecItemAdd(refreshQuery, nil)
        
        guard accessStatus == errSecSuccess,
              refreshStatus == errSecSuccess
        else {
            throw .tokensSaveError(accessStatus, refreshStatus)
        }
    }
    
    func getToken(tokenType: TokenType) throws(KeychainError) -> String {
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
            throw .tokenNotFound
        }
        
        guard let data = dataTypeRef as? Data,
              let token = String(data: data, encoding: .utf8)
        else
        {
            throw .invalidData
        }
        return token
    }
    
    func deleteTokens() throws(KeychainError) {
        let accessQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: TokenType.accessToken.rawValue
        ] as CFDictionary
        
        let refreshQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: TokenType.refreshToken.rawValue
        ] as CFDictionary
        
        let accessStatus = SecItemDelete(accessQuery)
        let refreshStatus = SecItemDelete(refreshQuery)
        guard accessStatus == errSecSuccess,
              refreshStatus == errSecSuccess
        else {
            throw .tokensDeleteError(accessStatus, refreshStatus)
        }
    }
}
