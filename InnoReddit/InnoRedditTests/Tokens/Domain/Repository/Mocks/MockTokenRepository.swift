//
//  MockTokenRepository.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.11.25.
//

@testable import InnoReddit

final class MockTokenRepository: TokenRepositoryProtocol {
    var needToSucceed: Bool = true
    var tokenRetrievalToReturn: TokenRetrieval!
    
    func exchangeCodeForTokens(code: String) async throws(TokenError) -> TokenRetrieval {
        if !needToSucceed {
            throw .invalidResponse
        }
        return tokenRetrievalToReturn
    }
    
    func refreshAccessToken(refreshToken: String) async throws(TokenError) -> TokenRetrieval {
        if !needToSucceed {
            throw .invalidResponse
        }
        return tokenRetrievalToReturn
    }
    
    func invalidateTokens() async throws(TokenError) {
        throw .unknownError
    }
}
