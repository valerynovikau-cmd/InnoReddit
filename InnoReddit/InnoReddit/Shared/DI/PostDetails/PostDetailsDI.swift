//
//  PostDetailsDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import Factory
import Foundation

extension Container {
    // MARK: - Post details view dependencies
    private var postDetailsPresenter: ParameterFactory<Post, PostDetailsPresenterProtocol> {
        self { @MainActor post in
            return PostDetailsPresenter(post: post)
        }
    }
    
    private var postDetailsStore: ParameterFactory<Post, PostDetailsStore> {
        self { @MainActor post in
            let store = PostDetailsStore()
            let output = self.postDetailsPresenter.resolve(post)
            store.output = output
            output.input = store
            return store
        }
    }
    
    var postDetailsView: ParameterFactory<Post, PostDetailsView> {
        self { @MainActor post in
            let store = self.postDetailsStore.resolve(post)
            return PostDetailsView(store: store)
        }
    }
    
    var postDetailsNetworkService: Factory<PostDetailsNetworkServiceProtocol> {
        self { @MainActor in
            return PostDetailsNetworkService()
        }
    }
    
    // MARK: - Post details image view dependencies
    private var postDetailsImagePresenter: ParameterFactory<URL?, PostDetailsImagePresenterProtocol> {
        self { @MainActor url in
            return PostDetailsImagePresenter(imageURL: url)
        }
    }
    
    var postDetailsImageStore: ParameterFactory<URL?, PostDetailsImageStore> {
        self { @MainActor url in
            let store = PostDetailsImageStore()
            let output =  self.postDetailsImagePresenter.resolve(url)
            store.output = output
            output.input = store
            return store
        }
    }
}
