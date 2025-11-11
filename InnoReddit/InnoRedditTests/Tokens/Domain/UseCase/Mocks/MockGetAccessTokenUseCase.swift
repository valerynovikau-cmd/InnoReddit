//
//  MockGetAccessTokenUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.11.25.
//

@testable import InnoReddit

final class MockGetAccessTokenUseCase: GetAccessTokenUseCaseProtocol {
    var needToSucceed: Bool = true
    
    func execute() throws -> String {
        if !needToSucceed {
            throw TokenStorageError.noTokenSaved
        }
        return ""
    }
}
