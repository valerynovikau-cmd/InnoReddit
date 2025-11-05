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
        Task {
            do {
                let code = try await self.webAuthSessionService.startSession()
                
                try await self.retrieveTokensUseCase.execute(code: code)
                self.input?.enableLoginButton()
                self.router.goToMainFlow()
            } catch let error as AuthenticationSessionError {
                let title = AuthenticationLocalizableStrings.errorMessageTitle
                switch error {
                case .accessDenied:
                    let message = AuthenticationLocalizableStrings.accessDeniedErrorMessage
                    self.input?.showAlert(title: title, message: message)
                    self.input?.enableLoginButton()
                case .invalidResponseURL:
                    self.input?.enableLoginButton()
                default:
                    let message = AuthenticationLocalizableStrings.serverErrorMessage
                    self.input?.showAlert(title: title, message: message)
                    self.input?.enableLoginButton()
                }
            } catch {
                let title = AuthenticationLocalizableStrings.errorMessageTitle
                let message = AuthenticationLocalizableStrings.authenticationErrorMessage
                self.input?.showAlert(title: title, message: message)
                self.input?.enableLoginButton()
            }
        }
    }
    
    func goToMainFlowIfAuthenticated() {
        do {
            let _ = try self.getAccessTokenUseCase.execute()
            self.router.goToMainFlow()
        } catch {
            
        }
    }
}
