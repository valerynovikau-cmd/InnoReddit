//
//  MainFeedViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import UIKit
import SwiftUI

class MainFeedViewController: UIViewController {
    var output: MainFeedPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.innoBackgroundColor.color
    }
}

extension MainFeedViewController: NavigationBarDisplayable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}

extension MainFeedViewController: MainFeedViewProtocol {
    
}

#Preview {
    ViewControllerPreview {
        let view = MainFeedViewController()
        return view
    }
    .ignoresSafeArea()
}
