//
//  AuthenticationPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import Foundation
import Factory

protocol AuthenticationViewPresenterProtocol: AnyObject {
    var input: AuthenticationViewProtocol? { get set }
    func didTapAuthenticateWithReddit()
    func goToMainFlowIfAuthenticated()
}

final class AuthenticationPresenter {
    weak var input: AuthenticationViewProtocol?
    private var router: AppRouterProtocol {
        Container.shared.appRouter(nil)
    }
    @Injected(\.webAuthSessionService) private var webAuthSessionService: ASWebAuthSessionServiceProtocol
    @Injected(\.retrieveTokensUseCase) private var retrieveTokensUseCase: RetrieveTokensUseCaseProtocol
    @Injected(\.getAccessTokenUseCase) private var getAccessTokenUseCase: GetAccessTokenUseCaseProtocol
    @Injected(\.authSessionManager) private var authSessionManager: AuthSessionManagerProtocol
    @Injected(\.authenticationNetworkService) private var authenticationNetworkService: AuthenticationNetworkServiceProtocol
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
                
                let response = try await self.authenticationNetworkService.getUserInfo()
                let user = UserModel(
                    username: response.name,
                    iconImageURL: response.iconImg,
                    totalKarma: response.totalKarma,
                    accountCreatedAt: Date(timeIntervalSince1970: TimeInterval(floatLiteral: response.created)),
                    subscribers: response.subreddit.subscribers
                )
                authSessionManager.updateUser(user: user)
                
                self.input?.enableLoginButton()
                self.goToMainFlowIfAuthenticated()
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
            } catch let error as APIError {
                errorTitle = error.errorTitle
                errorMessage = error.errorMessage
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
            guard let _ = self.authSessionManager.user else { return }
            self.router.showMainApp()
        } catch { }
    }
}
