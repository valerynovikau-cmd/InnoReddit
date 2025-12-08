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
        let output = Container.shared.postDetailsPresenter.resolve(post)
        var view = Container.shared.postDetailsView.resolve()
        
        output.input = view.store
        view.output = output
        
        let hostingVC = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingVC, animated: true)
    }
}
