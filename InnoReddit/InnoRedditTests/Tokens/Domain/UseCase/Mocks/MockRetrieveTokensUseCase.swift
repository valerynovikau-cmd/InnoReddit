//
//  MockRetrieveTokensUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 6.11.25.
//

@testable import InnoReddit

final class MockRetrieveTokensUseCase: RetrieveTokensUseCaseProtocol {
    var needToSucceed: Bool = true
    func execute(code: String) async throws {
        if !needToSucceed {
            throw TokenError.unknownError
        }
    }
}
