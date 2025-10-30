//
//  AuthenticationPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import Foundation

final class AuthenticationPresenter {
    weak var input: AuthenticationViewInput?
    private let router: AuthenticationRouterProtocol
    private let webAuthSessionService: ASWebAuthSessionService = ASWebAuthSessionService()
    
    init(router: AuthenticationRouterProtocol) {
        self.router = router
    }
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
