//
//  SceneDelegate.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 29.10.25.
//

import UIKit
import Factory

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var appRouter: AppRouterProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        self.appRouter = Container.shared.appRouter(window)
        self.appRouter?.showAuthenticationScreen()
    }
}

