//
//  MockASWebAuthSessionService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 6.11.25.
//

@testable import InnoReddit

final class MockASWebAuthSessionService: ASWebAuthSessionServiceProtocol {
    
    func startSession(scopes: [AuthScopes]) async throws -> String {
        return ""
    }
}
