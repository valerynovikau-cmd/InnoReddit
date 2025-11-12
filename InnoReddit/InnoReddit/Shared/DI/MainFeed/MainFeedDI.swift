//
//  MainFeedDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import Factory
import UIKit

extension Container {
    var mainFeedView: Factory<MainFeedViewProtocol> {
        self { @MainActor in
            MainFeedViewController()
        }
    }
    
    var mainFeedPresenter: Factory<MainFeedPresenterProtocol> {
        self { @MainActor in
            MainFeedPresenter()
        }
    }
    
    var mainFeedNetworkService: Factory<MainFeedNetworkServiceProtocol> {
        self { @MainActor in
            MainFeedNetworkService()
        }
    }
    
    var mainFeedModelMapper: Factory<MainFeedModelMapperProtocol> {
        self { @MainActor in
            MainFeedModelMapper()
        }
    }
}
