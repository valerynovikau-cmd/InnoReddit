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
    func showMainApp()
}

final class AppRouter: RouterProtocol {
    @Injected(\.rootNavigationController) var navigationController: UINavigationController
    private var window: UIWindow?
    
    init(window: UIWindow? = nil) {
        self.window = window
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

extension AppRouter: AppRouterProtocol {
    func showAuthenticationScreen() {
        let presenter = Container.shared.authenticationPresenter.resolve()
        let authenticationVC = Container.shared.authenticationView.resolve()
        
        authenticationVC.output = presenter
        presenter.input = authenticationVC
        
        guard let authVC = authenticationVC as? UIViewController else {
            return
        }
        
        self.navigationController.setViewControllers([authVC], animated: true)
    }
    
    //Here tab bar creation will be in the future
    func showMainApp() {
        self.navigationController.setViewControllers([], animated: true)
    }
}
