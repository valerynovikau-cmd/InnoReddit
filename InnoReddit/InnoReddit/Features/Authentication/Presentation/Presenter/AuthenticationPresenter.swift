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
    @Injected(\.retrieveTokensUseCase) private var retrieveTokensUseCase: RetrieveTokensUseCaseProtocol
    @Injected(\.getAccessTokenUseCase) private var getAccessTokenUseCase: GetAccessTokenUseCaseProtocol
}

extension AuthenticationPresenter: AuthenticationViewPresenterProtocol {
    func didTapAuthenticateWithReddit() {
        self.input?.disableLoginButton()
        Task { [weak self] in
            guard let self = self else { return }
            var errorTitle: String
            var errorMessage: String
            do {
                let scopes: [AuthScopes] = AuthScopes.allCases
                let code = try await self.webAuthSessionService.startSession(scopes: scopes)
                
                try await self.retrieveTokensUseCase.execute(code: code, scopes: scopes)
                self.input?.enableLoginButton()
                self.router.goToMainFlow()
                return
            } catch let error as AuthenticationSessionError {
                errorTitle = AuthenticationLocalizableStrings.errorMessageTitle
                switch error {
                case .accessDenied:
                    errorMessage = AuthenticationLocalizableStrings.accessDeniedErrorMessage
                case .invalidResponseURL:
                    self.input?.enableLoginButton()
                    return
                default:
                    errorMessage = AuthenticationLocalizableStrings.serverErrorMessage
                }
            } catch {
                errorTitle = AuthenticationLocalizableStrings.errorMessageTitle
                errorMessage = AuthenticationLocalizableStrings.authenticationErrorMessage
            }
            self.input?.enableLoginButton()
            self.input?.showAlert(title: errorTitle, message: errorMessage)
        }
    }
    
    func goToMainFlowIfAuthenticated() {
        do {
            let _ = try self.getAccessTokenUseCase.execute()
            self.router.goToMainFlow()
        } catch { }
    }
}
