//
//  TokenSecureStorageRepositoryProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

protocol TokenSecureStorageRepositoryProtocol {
    func getAccessToken() -> String?
    func refreshAccessToken() -> Void
    func invalidateTokens() -> Void
    
}
