//
//  MainFeedDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import Factory
import UIKit

extension Container {
    var postsView: Factory<PostsViewProtocol> {
        self { @MainActor in
            PostsViewController()
        }
    }
    
    var postsPresenter: Factory<PostsPresenterProtocol> {
        self { @MainActor in
            PostsPresenter(category: .hot)
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
