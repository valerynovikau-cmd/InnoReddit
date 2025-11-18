//
//  TokenRepositoryProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

enum TokenError: Error {
    case invalidRequest
    case invalidResponse
    case invalidData
    case unknownError
}

protocol TokenRepositoryProtocol: AnyObject {
    func exchangeCodeForTokens(code: String) async throws(TokenError) -> TokenRetrieval
    func refreshAccessToken(refreshToken: String) async throws(TokenError) -> TokenRetrieval
    func invalidateTokens(tokenToRevoke: String, tokenAccessType: TokenAccessType) async throws(TokenError) -> Void
}
