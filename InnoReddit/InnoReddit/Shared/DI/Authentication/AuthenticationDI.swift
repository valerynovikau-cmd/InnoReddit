//
//  AuthenticationDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory
import UIKit

extension Container {
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
    
    var authSessionManager: Factory<AuthSessionManagerProtocol> {
        self { @MainActor in
            AuthSessionManager()
        }.singleton
    }
    
    var authenticationNetworkService: Factory<AuthenticationNetworkServiceProtocol> {
        self { @MainActor in
            AuthenticationNetworkService()
        }
    }
}
