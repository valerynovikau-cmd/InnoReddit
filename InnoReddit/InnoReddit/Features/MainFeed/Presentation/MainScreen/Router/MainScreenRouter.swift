//
//  MainScreenRouter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 14.11.25.
//

import UIKit
import Factory

protocol MainScreenRouterProtocol: AnyObject {
    
}

final class MainScreenRouter: RouterProtocol {
    @Injected(\.mainFeedNavigationController) var navigationController: UINavigationController
}

extension MainScreenRouter: MainScreenRouterProtocol {
    
}
