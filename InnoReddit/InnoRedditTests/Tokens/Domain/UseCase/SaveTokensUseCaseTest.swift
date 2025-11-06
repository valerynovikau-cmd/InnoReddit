//
//  SaveTokensUseCaseTest.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.11.25.
//

import XCTest
import Factory
@testable import InnoReddit

final class SaveTokensUseCaseTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }
    
    func test_savedToken_savedCorrectly() throws {
//        let accessToken = "access_token"
//        let refreshToken = "refresh_token"
        
//        Container.shared.tokenStorageRepository.register {
//            MockTokenStorageRepository()
//        }
        let skebob = SaveTokensUseCase()
        
//        let saveUseCase = Container.shared.saveTokensUseCase.resolve()
//        let getAccessTokenUseCase = Container.shared.getAccessTokenUseCase.resolve()
//        let getRefreshTokenUseCase = Container.shared.getRefreshTokenUseCase.resolve()
//        
//        try saveUseCase.execute(accessToken: accessToken, refreshToken: refreshToken)
//        
//        let accessTokenResult = try getAccessTokenUseCase.execute()
//        let refreshTokenResult = try getRefreshTokenUseCase.execute()
//        
//        XCTAssertEqual(accessToken, accessTokenResult)
//        XCTAssertEqual(refreshToken, refreshTokenResult)
    }
    
    
}
