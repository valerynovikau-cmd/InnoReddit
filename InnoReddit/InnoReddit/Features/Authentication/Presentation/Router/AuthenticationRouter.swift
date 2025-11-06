//
//  AuthenticationRouter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import UIKit

final class AuthenticationRouter: RouterProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension AuthenticationRouter: AuthenticationRouterProtocol {
    func goToMainFlow() {
        
    }
}
