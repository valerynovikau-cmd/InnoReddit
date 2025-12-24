//
//  ProfileRouter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 23.12.25.
//

import UIKit
import SwiftUI
import Factory

final class ProfileRouter: RouterProtocol {
    @Injected(\.profileNavigationController) var navigationController: UINavigationController
}

extension ProfileRouter: MainScreenRouterProtocol {
    func showPostDetails(post: Post) {
        let view = Container.shared.postDetailsView.resolve(post)
        let hostingVC = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingVC, animated: true)
    }
}
