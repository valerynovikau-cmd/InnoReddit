//
//  RetrieveTokensUseCaseTest.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.11.25.
//

import XCTest
import Factory
@testable import InnoReddit

final class RetrieveTokensUseCaseTest: XCTestCase {

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
    
    func test_successfulRetrieval_successfulSaving() async throws {
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
        let useCase = Container.shared.retrieveTokensUseCase.resolve()
        
        try await useCase.execute(code: "", scopes: self.tokenToRetrieve.scope)
    }
    
    func test_successfulRetrieval_unSuccessfulSaving() async throws {
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
        let useCase = Container.shared.retrieveTokensUseCase.resolve()
        
        do {
            try await useCase.execute(code: "", scopes: self.tokenToRetrieve.scope)
            XCTFail("No error was thrown")
        } catch {
            XCTAssertNotNil(error as? TokenStorageError)
        }
    }
    
    func test_unsuccessfulRetrieval() async throws {
        Container.shared.tokenRepository.register {
            let mock = MockTokenRepository()
            mock.needToSucceed = false
            return mock
        }
        Container.shared.saveTokensUseCase.register {
            let mock = MockSaveTokensUseCase()
            return mock
        }
        let useCase = Container.shared.retrieveTokensUseCase.resolve()
        
        do {
            try await useCase.execute(code: "", scopes: self.tokenToRetrieve.scope)
            XCTFail("No error was thrown")
        } catch {
            XCTAssertNotNil(error as? TokenError)
        }
    }
}
