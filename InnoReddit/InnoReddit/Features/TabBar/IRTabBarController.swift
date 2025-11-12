//
//  IRTabBarController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import UIKit
import Factory

enum IRTabBarItem: Int, CaseIterable {
    case mainFeed = 0
    case createPost = 1
    case settings = 2
    
    var getTabBarItem: UITabBarItem {
        switch self {
        case .mainFeed:
            UITabBarItem(
                title: TabBarLocalizableStrings.mainFeedTabBarTitle,
                image: UIImage(systemName: TabBarLocalizableStrings.mainFeedSFSymbolName),
                selectedImage: UIImage(systemName: TabBarLocalizableStrings.mainFeedSFSymbolNameSelected)
            )
        case .createPost:
            UITabBarItem(
                title: TabBarLocalizableStrings.createPostTabBarTitle,
                image: UIImage(systemName: TabBarLocalizableStrings.createPostSFSymbolName),
                selectedImage: UIImage(systemName: TabBarLocalizableStrings.createPostSFSymbolNameSelected)
            )
        case .settings:
            UITabBarItem(
                title: TabBarLocalizableStrings.settingsTabBarTitle,
                image: UIImage(systemName: TabBarLocalizableStrings.settingsSFSymbolName),
                selectedImage: UIImage(systemName: TabBarLocalizableStrings.settingsSFSymbolNameSelected)
            )
        }
    }
}

class IRTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Asset.Colors.innoBackgroundColor.color
        
        appearance.stackedLayoutAppearance.selected.iconColor = Asset.Colors.innoOrangeColor.color
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: Asset.Colors.innoOrangeColor.color]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension IRTabBarController: NavigationBarDisplayable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}
