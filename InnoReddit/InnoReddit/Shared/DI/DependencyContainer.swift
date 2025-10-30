//
//  DependencyContainer.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import Factory
import UIKit

// MARK: Navigation controller resolving
extension Container {
    var rootNavigationController: Factory<UINavigationController> {
        self { @MainActor in
            UINavigationController()
        }.singleton
    }
}

// MARK: - Authentication feature resolving
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
