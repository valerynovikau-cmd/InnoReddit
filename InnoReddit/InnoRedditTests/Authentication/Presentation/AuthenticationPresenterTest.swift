//
//  AuthenticationPresenterTest.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 6.11.25.
//

import XCTest
import Factory
@testable import InnoReddit

final class AuthenticationPresenterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }
    
    func test() {
        Container.shared.webAuthSessionService.register {
            MockASWebAuthSessionService()
        }
//        Container.shared.authenticationRouter.register {
//            DummyAuthenticationRouter()
//        }
        Container.shared.getAccessTokenUseCase.register {
            MockGetAccessTokenUseCase()
        }
        Container.shared.retrieveTokensUseCase.register {
            let usecase = MockRetrieveTokensUseCase()
            usecase.needToSucceed = true
            return usecase
        }
        
        let presenter = Container.shared.authenticationPresenter.resolve()
    }
}
