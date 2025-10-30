//
//  AppRouter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import UIKit

protocol AppRouterProtocol: AnyObject {
    func showAuthenticationScreen()
}

final class AppRouter: RouterProtocol {
    var navigationController: UINavigationController?
    private(set) var window: UIWindow?
    
    init(window: UIWindow?) {
        self.navigationController = UINavigationController()
        self.window = window
    }
}

extension AppRouter: AppRouterProtocol {
    func showAuthenticationScreen() {
        guard let navigationController = self.navigationController else { return }
        
        let authenticationRouter = AuthenticationRouter(navigationController: navigationController)
        let authenticationVC = AuthenticationViewController()
        let presenter = AuthenticationPresenter(router: authenticationRouter)
        
        authenticationVC.output = presenter
        presenter.input = authenticationVC
        
        navigationController.setViewControllers([authenticationVC], animated: false)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}
