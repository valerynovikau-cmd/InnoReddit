//
//  NavigationControllerDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

import Factory
import UIKit

extension Container {
    var rootNavigationController: Factory<UINavigationController> {
        self { @MainActor in
            IRNavigationController()
        }.singleton
    }
    
    var mainFeedNavigationController: ParameterFactory<UIViewController, UINavigationController> {
        self { @MainActor vc in
            IRNavigationController(rootViewController: vc)
        }.singleton
    }
}
