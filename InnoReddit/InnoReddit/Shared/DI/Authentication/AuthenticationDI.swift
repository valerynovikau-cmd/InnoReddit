//
//  AuthenticationDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory
import UIKit

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
    
    var authenticationPresenter: Factory<AuthenticationViewPresenterProtocol> {
        self { @MainActor in
            AuthenticationPresenter()
        }
    }
    
    var authenticationView: Factory<AuthenticationViewProtocol> {
        self { @MainActor in
            AuthenticationViewController()
        }
    }
}
