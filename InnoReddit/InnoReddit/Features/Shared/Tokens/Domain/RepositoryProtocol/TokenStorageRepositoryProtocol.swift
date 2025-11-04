//
//  TokenStorageRepositoryProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

enum TokenStorageError: Error {
    case noTokenSaved
    case saveTokensFailed
    case deleteTokensFailed
    case invalidTokenData
    case unknownError
}

protocol TokenStorageRepositoryProtocol {
    func getToken(tokenType: TokenType) throws(TokenStorageError) -> String
    func saveTokens(accessToken: String, refreshToken: String) throws(TokenStorageError) -> Void
    func clearTokens() throws(TokenStorageError) -> Void
}
