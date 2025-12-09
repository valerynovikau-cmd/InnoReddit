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
    
    // MARK: - Post details image view dependencies
    var postDetailsImagePresenter: ParameterFactory<URL?, PostDetailsImagePresenterProtocol> {
        self { @MainActor url in
            return PostDetailsImagePresenter(imageURL: url)
        }
    }
    
    private var postDetailsImageStore: Factory<PostDetailsImageStore> {
        self { @MainActor in
            return PostDetailsImageStore()
        }
    }
    
    var postDetailsImageView: Factory<PostDetailsImageView> {
        self { @MainActor in
            let store = self.postDetailsImageStore()
            return PostDetailsImageView(store: store)
        }
    }
}
