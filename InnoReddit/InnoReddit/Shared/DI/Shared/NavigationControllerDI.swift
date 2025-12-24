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
    
    var mainFeedNavigationController: Factory<UINavigationController> {
        self { @MainActor in
            IRNavigationController()
        }.singleton
    }
    
    var profileNavigationController: Factory<UINavigationController> {
        self { @MainActor in
            IRNavigationController()
        }.singleton
    }
}
