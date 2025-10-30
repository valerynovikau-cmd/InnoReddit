//
//  AuthenticationPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import Foundation
import Factory

final class AuthenticationPresenter {
    weak var input: AuthenticationViewInput?
    @Injected(\.authenticationRouter) private var router: AuthenticationRouterProtocol
    @Injected(\.webAuthSessionService) private var webAuthSessionService: ASWebAuthSessionServiceProtocol
}

extension AuthenticationPresenter: AuthenticationViewOutput {
    func didTapAuthenticateWithReddit() {
        Task {
            do {
                let url = try await self.webAuthSessionService.startSession()
                await MainActor.run {
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                    if let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
                        self.input?.showAlert(title: "Success", message: code)
                    } else {
                        self.input?.showAlert(title: "Error", message: "An error occured")
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
