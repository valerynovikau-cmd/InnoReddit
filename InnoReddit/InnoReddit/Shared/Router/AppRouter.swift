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
            let mainScreenView = Container.shared.mainScreenView.resolve()
            let mainFeedNavigationController = Container.shared.mainFeedNavigationController.resolve()
            let mainScreenRouter = Container.shared.mainScreenRouter.resolve()
            
            let controllersWithCategoriesStrings: [(UIViewController, String)] = MainFeedCategory.allCases.compactMap {
                let view = Container.shared.postsView.resolve()
                let presenter = Container.shared.postsPresenter.resolve($0)
                
                view.output = presenter
                presenter.input = view
                presenter.router = mainScreenRouter
                
                (view as? PostsViewController)?.delegate = (mainScreenView as? PostsSearchBarDelegateProtocol)
                
                guard let vc = (view as? UIViewController) else {
                    return nil
                }
                return (vc, $0.titleString)
            }
            
            mainScreenView.setPageControllerViewControllers(controllersWithCategoriesStrings: controllersWithCategoriesStrings)
            
            guard let mainScreenVC = (mainScreenView as? UIViewController) else {
                return nil
            }
            mainFeedNavigationController.setViewControllers([mainScreenVC], animated: false)
            
            vc = mainFeedNavigationController
        case .createPost:
            vc = UIViewController()
        case .profile:
            vc = UIViewController()
        }
        
        vc.tabBarItem = item.getTabBarItem
        return vc
    }
}

extension AppRouter: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            switch index {
            case IRTabBarItem.createPost.rawValue:
                let vc = UIViewController()
                self.navigationController.pushViewController(vc, animated: true)
                return false
            case IRTabBarItem.mainFeed.rawValue:
                if tabBarController.selectedIndex == index,
                   let navigationVC = viewController as? IRNavigationController,
                   let mainScreenVC = navigationVC.topViewController as? MainScreenViewProtocol
                {
                    mainScreenVC.scrollCurrentViewControllerToTop()
                }
            default:
                return true
            }
        }
        return true
    }
}
