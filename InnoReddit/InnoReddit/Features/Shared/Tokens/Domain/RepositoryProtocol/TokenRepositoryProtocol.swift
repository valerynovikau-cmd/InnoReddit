//
//  TokenRepositoryProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

protocol TokenRepositoryProtocol: AnyObject {
    func exchangeCodeForTokens(code: String) async throws -> TokenRetrieval
    func refreshAccessToken(refreshToken: String) async throws -> TokenRetrieval
    func invalidateTokens() async throws -> Void
}
