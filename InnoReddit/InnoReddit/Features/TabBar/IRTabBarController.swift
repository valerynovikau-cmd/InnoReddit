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
    case profile = 2
    
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
        case .profile:
            UITabBarItem(
                title: TabBarLocalizableStrings.profileTabBarTitle,
                image: UIImage(systemName: TabBarLocalizableStrings.profileSFSymbolName),
                selectedImage: UIImage(systemName: TabBarLocalizableStrings.profileSFSymbolNameSelected)
            )
        }
    }
}

class IRTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Asset.Assets.Colors.innoBackgroundColor.color
        
        let stackedLayoutAppearance = appearance.stackedLayoutAppearance
        stackedLayoutAppearance.selected.iconColor = Asset.Assets.Colors.innoOrangeColor.color
        stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Asset.Assets.Colors.innoOrangeColor.color
        ]
        
        stackedLayoutAppearance.normal.iconColor = .gray
        stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]
        
        appearance.stackedLayoutAppearance = stackedLayoutAppearance
        
        let compactInlineLayoutAppearance = appearance.compactInlineLayoutAppearance
        compactInlineLayoutAppearance.selected.iconColor = Asset.Assets.Colors.innoOrangeColor.color
        compactInlineLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Asset.Assets.Colors.innoOrangeColor.color
        ]
        
        compactInlineLayoutAppearance.normal.iconColor = .gray
        compactInlineLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]
        
        appearance.compactInlineLayoutAppearance = compactInlineLayoutAppearance
        
        let inlineLayoutAppearance = appearance.inlineLayoutAppearance
        inlineLayoutAppearance.selected.iconColor = Asset.Assets.Colors.innoOrangeColor.color
        inlineLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Asset.Assets.Colors.innoOrangeColor.color
        ]
        
        inlineLayoutAppearance.normal.iconColor = .gray
        inlineLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]
        
        appearance.inlineLayoutAppearance = inlineLayoutAppearance
        
        
        tabBar.standardAppearance = appearance
    }
}

extension IRTabBarController: NavigationBarDisplayable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}
