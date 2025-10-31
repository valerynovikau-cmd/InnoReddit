//
//  TokenStorageRepositoryProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

protocol TokenStorageRepositoryProtocol {
    func getTokens() throws -> (accessToken: String, refreshToken: String)?
    func saveTokens(accessToken: String, refreshToken: String) throws -> Void
    func clearTokens() throws -> Void
}
