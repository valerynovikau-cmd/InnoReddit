//
//  ProfileDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 23.12.25.
//

import UIKit
import Factory

extension Container {
    var profileView: Factory<ProfileViewProtocol> {
        self { @MainActor in
            ProfileViewController()
        }
    }
    
    var profileRouter: Factory<MainScreenRouterProtocol> {
        self { @MainActor in
            ProfileRouter()
        }
    }
    
    var profilePostsPresenter: ParameterFactory<ProfilePostsCategory, PostsPresenterProtocol> {
        self { @MainActor category in
            ProfilePostsPresenter(category: category)
        }
    }
    
    var profilePostsNetworkService: Factory<ProfilePostsNetworkServiceProtocol> {
        self { @MainActor in
            ProfilePostsNetworkService()
        }
    }
    
    var profilePresenter: Factory<ProfilePresenterProtocol> {
        self { @MainActor in
            ProfilePresenter()
        }
    }
}
