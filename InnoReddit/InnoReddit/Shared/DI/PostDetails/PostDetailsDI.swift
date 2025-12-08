//
//  PostDetailsDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import Factory

extension Container {
    var postDetailsPresenter: ParameterFactory<Post, PostDetailsPresenterProtocol> {
        self { @MainActor post in
            return PostDetailsPresenter(post: post)
        }
    }
    
    private var postDetailsStore: Factory<PostDetailsStore> {
        self { @MainActor in
            return PostDetailsStore()
        }
    }
    
    var postDetailsView: Factory<PostDetailsView> {
        self { @MainActor in
            let store = self.postDetailsStore()
            return PostDetailsView(store: store)
        }
    }
    
    var postDetailsNetworkService: Factory<PostDetailsNetworkServiceProtocol> {
        self { @MainActor in
            return PostDetailsNetworkService()
        }
    }
}
