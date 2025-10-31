//
//  AuthenticationPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import Foundation
import Factory

final class AuthenticationPresenter {
    weak var input: AuthenticationViewProtocol?
    @Injected(\.authenticationRouter) private var router: AuthenticationRouterProtocol
    @Injected(\.webAuthSessionService) private var webAuthSessionService: ASWebAuthSessionServiceProtocol
    @Injected(\.retrieveTokensUseCase) private var retrieveTokensUseCase: RetrieveTokensUseCase
}

extension AuthenticationPresenter: AuthenticationViewPresenterProtocol {
    func didTapAuthenticateWithReddit() {
        Task {
            do {
                let url = try await self.webAuthSessionService.startSession()
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                if let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
                    let tokenRetrieval = try await self.retrieveTokensUseCase.execute(code: code)
                    // TODO: Save token to keychain, 
                } else {
                    throw NSError()
                }
            } catch {
                print(error)
            }
        }
    }
}
