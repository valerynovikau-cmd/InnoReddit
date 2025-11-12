//
//  MainFeedPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import Factory

final class MainFeedPresenter {
    weak var input: MainFeedViewProtocol?
    @Injected(\.mainFeedNetworkService) private var networkService: MainFeedNetworkServiceProtocol
    @Injected(\.mainFeedModelMapper) private var modelMapper: MainFeedModelMapperProtocol
    
    private(set) var bestPosts: [Post] = []
    private(set) var hotPosts: [Post] = []
    private(set) var newPosts: [Post] = []
    private(set) var topPosts: [Post] = []
    private(set) var risingPosts: [Post] = []
}

extension MainFeedPresenter: MainFeedPresenterProtocol {
    func preformHotPostsRetrieval() {
        Task {
            do {
                let posts = try await self.networkService.getHotPosts()
                let mappedPosts = self.modelMapper.map(from: posts)
                self.hotPosts = mappedPosts
                self.input?.onHotPostsUpdated()
            } catch {
                //Это не bad practice если тебе было весело
                print(error)
                fatalError()
            }
        }
    }
}
