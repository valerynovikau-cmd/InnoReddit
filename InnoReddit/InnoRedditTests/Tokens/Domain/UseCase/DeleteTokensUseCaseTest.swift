//
//  DeleteTokensUseCaseTest.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 6.11.25.
//

import XCTest
import Factory
@testable import InnoReddit

@MainActor
final class DeleteTokensUseCaseTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }
    
    func test_tokensDeletedCorrectly() throws {
        Container.shared.tokenStorageRepository.register {
            MockTokenStorageRepository()
        }
        
        let deleteUseCase = Container.shared.deleteTokensUseCase.resolve()
        let getAccessTokenUseCase = Container.shared.getAccessTokenUseCase.resolve()
        let getRefreshTokenUseCase = Container.shared.getRefreshTokenUseCase.resolve()
        
        try deleteUseCase.execute()
        
        do {
            let _ = try getAccessTokenUseCase.execute()
            XCTFail("No error was thrown")
        } catch {
            XCTAssert(error as? TokenStorageError == .noTokenSaved)
        }
        
        do {
            let _ = try getRefreshTokenUseCase.execute()
            XCTFail("No error was thrown")
        } catch {
            XCTAssert(error as? TokenStorageError == .noTokenSaved)
        }
    }
    
    
}
