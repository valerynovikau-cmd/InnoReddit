//
//  TokenStorageRepository.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

final class TokenStorageRepository: TokenStorageRepositoryProtocol {
    
    @Injected(\.keychainDataSource) private var keychainDataSource: KeychainDataSource
    
    func getToken(tokenAccessType: TokenAccessType) throws(TokenStorageError) -> String {
        do {
            return try self.keychainDataSource.getToken(tokenAccessType: tokenAccessType)
        } catch {
            switch error {
            case .invalidData:
                throw .invalidTokenData
            case .tokenNotFound:
                throw .noTokenSaved
            default:
                throw .unknownError
            }
        }
    }
    
    func saveTokens(accessToken: String, refreshToken: String) throws(TokenStorageError) {
        do {
            try self.keychainDataSource.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
        } catch {
            switch error {
            case .tokensSaveError, .tokensDeleteError:
                throw .saveTokensFailed
            default:
                throw .unknownError
            }
        }
    }
    
    func clearTokens() throws(TokenStorageError) {
        do {
            try self.keychainDataSource.deleteTokens()
        } catch {
            switch error {
            case .tokensDeleteError:
                throw .deleteTokensFailed
            default:
                throw .unknownError
            }
        }
    }
}
