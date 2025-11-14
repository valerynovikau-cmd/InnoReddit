//
//  MainFeedDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import Factory
import UIKit

extension Container {
    var mainScreenView: Factory<UIViewController> {
        self { @MainActor in
            MainScreenViewController()
        }
    }
    
    var mainScreenRouter: Factory<MainScreenRouterProtocol> {
        self { @MainActor in
            MainScreenRouter()
        }
    }
    
    var postsView: Factory<PostsViewProtocol> {
        self { @MainActor in
            PostsViewController()
        }
    }
    
    var postsPresenter: ParameterFactory<MainFeedCategory, PostsPresenterProtocol> {
        self { @MainActor category in
            PostsPresenter(category: category)
        }
    }
    
    var postsNetworkService: Factory<PostsNetworkServiceProtocol> {
        self { @MainActor in
            PostsNetworkService()
        }
    }
    
    var postsModelMapper: Factory<PostsModelMapperProtocol> {
        self { @MainActor in
            PostsModelMapper()
        }
    }
}
