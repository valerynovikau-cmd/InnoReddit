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

final class AppRouter: NSObject, RouterProtocol {
    @Injected(\.rootNavigationController) var navigationController: UINavigationController
    private var window: UIWindow?
    
    init(window: UIWindow? = nil) {
        super.init()
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
    
    func showMainApp() {
        let tabBarController = Container.shared.tabBarController.resolve()
        tabBarController.delegate = self
        
        let pages: [IRTabBarItem] = IRTabBarItem.allCases.sorted(by: { $0.rawValue < $1.rawValue })
        
        let controllers: [UIViewController] = pages.compactMap(getTabBarController)
        
        tabBarController.setViewControllers(controllers, animated: false)
        self.navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    private func getTabBarController(_ item: IRTabBarItem) -> UIViewController? {
        var vc: UIViewController!
        
        switch item {
        case .mainFeed:
            let mainFeedView = Container.shared.mainFeedView.resolve()
            let mainFeedPresenter = Container.shared.mainFeedPresenter.resolve()
            mainFeedView.output = mainFeedPresenter
            mainFeedPresenter.input = mainFeedView
            
            guard let mainFeedVC = (mainFeedView as? UIViewController) else {
                return nil
            }
            let mainFeedNavigationController = Container.shared.mainFeedNavigationController.resolve(mainFeedVC)
            
            vc = mainFeedNavigationController
        case .createPost:
            vc = UIViewController()
        case .settings:
            vc = UIViewController()
        }
        
        vc.tabBarItem = item.getTabBarItem
        return vc
    }
}

extension AppRouter: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController), index == IRTabBarItem.createPost.rawValue {
            let vc = UIViewController()
            self.navigationController.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
}
