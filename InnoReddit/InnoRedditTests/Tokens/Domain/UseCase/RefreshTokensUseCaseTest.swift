//
//  RefreshTokensUseCaseTest.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.11.25.
//

import XCTest
import Factory
@testable import InnoReddit

final class RefreshTokensUseCaseTest: XCTestCase {

    var tokenToRetrieve = TokenRetrieval(
        accessToken: "access_token",
        tokenType: "bearer",
        expiresIn: 1000,
        scope: [.read, .edit],
        refreshToken: "refresh_token"
    )
    
    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }
    
    func test_successfulRefresh_successfulSaving() async throws {
        Container.shared.tokenRepository.register { [weak self] in
            let mock = MockTokenRepository()
            mock.needToSucceed = true
            mock.tokenRetrievalToReturn = self?.tokenToRetrieve
            return mock
        }
        Container.shared.saveTokensUseCase.register {
            let mock = MockSaveTokensUseCase()
            mock.needToSucceed = true
            return mock
        }
        let useCase = Container.shared.refreshAccessTokenUseCase.resolve()
        
        try await useCase.execute(refreshToken: "")
    }
    
    func test_successfulRefresh_unSuccessfulSaving() async throws {
        Container.shared.tokenRepository.register { [weak self] in
            let mock = MockTokenRepository()
            mock.needToSucceed = true
            mock.tokenRetrievalToReturn = self?.tokenToRetrieve
            return mock
        }
        Container.shared.saveTokensUseCase.register {
            let mock = MockSaveTokensUseCase()
            mock.needToSucceed = false
            return mock
        }
        let useCase = Container.shared.refreshAccessTokenUseCase.resolve()
        
        do {
            try await useCase.execute(refreshToken: "")
            XCTFail("No error was thrown")
        } catch {
            XCTAssertNotNil(error as? TokenStorageError)
        }
    }
    
    func test_usSuccessfulRefresh() async throws {
        Container.shared.tokenRepository.register {
            let mock = MockTokenRepository()
            mock.needToSucceed = false
            return mock
        }
        Container.shared.saveTokensUseCase.register {
            let mock = MockSaveTokensUseCase()
            return mock
        }
        let useCase = Container.shared.refreshAccessTokenUseCase.resolve()
        
        do {
            try await useCase.execute(refreshToken: "")
            XCTFail("No error was thrown")
        } catch {
            XCTAssertNotNil(error as? TokenError)
        }
    }
}
