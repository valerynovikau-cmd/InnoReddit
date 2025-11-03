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
    @Injected(\.getAccessTokenUseCase) private var getAccessTokenUseCase: GetAccessTokenUseCase
}

extension AuthenticationPresenter: AuthenticationViewPresenterProtocol {
    func didTapAuthenticateWithReddit() {
        Task {
            do {
                let code = try await self.webAuthSessionService.startSession()
                
                try await self.retrieveTokensUseCase.execute(code: code)
                
                router.goToMainFlow()
            } catch {
                print(error)
            }
        }
    }
    
    func goToMainFlowIfAuthenticated() {
        do {
            let _ = try self.getAccessTokenUseCase.execute()
            router.goToMainFlow()
        } catch {
            
        }
    }
}
