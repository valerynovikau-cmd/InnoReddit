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
    @Injected(\.saveTokensUseCase) private var saveTokensUseCase: SaveTokensUseCase
    @Injected(\.getAccessTokenUseCase) private var getAccessTokenUseCase: GetAccessTokenUseCase
}

extension AuthenticationPresenter: AuthenticationViewPresenterProtocol {
    func didTapAuthenticateWithReddit() {
        Task {
            do {
                let url = try await self.webAuthSessionService.startSession()
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                guard let code = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
                    throw NSError()
                }
                
                let tokenRetrieval = try await self.retrieveTokensUseCase.execute(code: code)
                guard let refreshToken = tokenRetrieval.refreshToken else {
                    throw NSError()
                }
                
                try saveTokensUseCase.execute(accessToken: tokenRetrieval.accessToken, refreshToken: refreshToken)
                
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
