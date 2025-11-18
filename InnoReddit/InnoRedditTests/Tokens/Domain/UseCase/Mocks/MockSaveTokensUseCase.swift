//
//  MockSaveTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.11.25.
//

@testable import InnoReddit

final class MockSaveTokensUseCase: SaveTokensUseCaseProtocol {
    var needToSucceed: Bool = true
    func execute(accessToken: String, refreshToken: String) throws {
        if !needToSucceed {
            throw TokenStorageError.saveTokensFailed
        }
    }
}
