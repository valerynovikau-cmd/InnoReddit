//
//  SceneDelegate.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 29.10.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var appRouter: AppRouter?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.appRouter = AppRouter(window: window)
        self.appRouter?.showAuthenticationScreen()
    }
}

