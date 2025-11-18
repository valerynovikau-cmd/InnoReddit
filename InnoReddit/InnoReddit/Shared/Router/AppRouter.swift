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
        let presenter = Container.shared.authenticationPresenter.resolve()
        let authenticationVC = Container.shared.authenticationView.resolve()
        
        authenticationVC.output = presenter
        presenter.input = authenticationVC
        
        guard let authVC = authenticationVC as? UIViewController else {
            return
        }
        
        self.navigationController.setViewControllers([authVC], animated: false)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}
