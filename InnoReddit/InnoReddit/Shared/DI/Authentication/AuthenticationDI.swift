//
//  AuthenticationDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory

extension Container {
    var authenticationRouter: Factory<AuthenticationRouterProtocol> {
        self { @MainActor in
            AuthenticationRouter(navigationController: self.rootNavigationController())
        }
    }
    
    var webAuthSessionService: Factory<ASWebAuthSessionServiceProtocol> {
        self { @MainActor in
            ASWebAuthSessionService()
        }
    }
    
//    var authenticationPresenter: Factory<AuthenticationViewOutput> {
//        self { @MainActor in
//            AuthenticationPresenter(router: self.authenticationRouter())
//        }
//    }
}
