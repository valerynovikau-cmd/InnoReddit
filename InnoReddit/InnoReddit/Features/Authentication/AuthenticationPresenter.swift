//
//  AuthenticationPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

final class AuthenticationPresenter {
    weak var input: AuthenticationViewInput?
    private let router: AuthenticationRouterProtocol
    
    init(router: AuthenticationRouterProtocol) {
        self.router = router
    }
}

extension AuthenticationPresenter: AuthenticationViewOutput {
    func didTapAuthenticateWithReddit() {
        
    }
}
