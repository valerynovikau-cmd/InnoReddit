//
//  IRNavigationController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import UIKit

class IRNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        navigationBar.tintColor = Asset.Assets.Colors.innoOrangeColor.color
    }
}

extension IRNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? NavigationBarDisplayable {
            setNavigationBarHidden(vc.prefersNavigationBarHidden, animated: animated)
        } else {
            setNavigationBarHidden(false, animated: animated)
        }
    }
}
