//
//  SceneDelegate.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 29.10.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let vc = DefaultViewController()
        let navigationVC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
    }
}

