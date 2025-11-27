//
//  TabBarDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import UIKit
import Factory

extension Container {
    var tabBarController: Factory<UITabBarController> {
        self { @MainActor in
            IRTabBarController()
        }
    }
}
