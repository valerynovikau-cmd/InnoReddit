//
//  MainScreenRouter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 14.11.25.
//

import UIKit
import SwiftUI
import Factory

protocol MainScreenRouterProtocol: AnyObject {
    func showPostDetails(post: Post)
}

final class MainScreenRouter: RouterProtocol {
    @Injected(\.mainFeedNavigationController) var navigationController: UINavigationController
}

extension MainScreenRouter: MainScreenRouterProtocol {
    func showPostDetails(post: Post) {
        let hostingVC = UIHostingController(rootView: PostDetailsView())
        navigationController.pushViewController(hostingVC, animated: true)
    }
}
