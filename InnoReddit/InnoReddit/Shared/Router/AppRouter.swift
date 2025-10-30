//
//  AppRouter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import UIKit
import Factory

protocol AppRouterProtocol: AnyObject {
    func showAuthenticationScreen()
}

final class AppRouter: RouterProtocol {
    @Injected(\.rootNavigationController) var navigationController: UINavigationController
    private(set) var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
}

extension AppRouter: AppRouterProtocol {
    func showAuthenticationScreen() {
        let authenticationRouter = Container.shared.authenticationRouter()
        
        let presenter = AuthenticationPresenter(router: authenticationRouter)
        let authenticationVC = AuthenticationViewController()
        
        authenticationVC.output = presenter
        presenter.input = authenticationVC

        self.navigationController.setViewControllers([authenticationVC], animated: false)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}
