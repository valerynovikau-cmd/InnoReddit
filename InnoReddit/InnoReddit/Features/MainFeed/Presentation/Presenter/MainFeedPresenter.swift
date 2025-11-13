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
    private(set) var hotPostsAfter: String?
    private(set) var newPosts: [Post] = []
    private(set) var topPosts: [Post] = []
    private(set) var risingPosts: [Post] = []
    
    private(set) var isRetrievingHotPosts: Bool = false
}

extension MainFeedPresenter: MainFeedPresenterProtocol {
    func preformHotPostsRetrieval() {
        Task {
            do {
                guard !self.isRetrievingHotPosts else { return }
                self.isRetrievingHotPosts = true
                
                let posts = try await self.networkService.getHotPosts(after: nil)
                let mappedPosts = self.modelMapper.map(from: posts)
                self.hotPosts = mappedPosts
                self.hotPostsAfter = posts.data.after
                
                self.isRetrievingHotPosts = false
                self.input?.onHotPostsUpdated()
            } catch {
                self.isRetrievingHotPosts = false
                //Это не bad practice если тебе было весело
                print(error)
                fatalError()
            }
        }
    }
    
    func performHotPostsPaginatedRetrieval() {
        Task {
            do {
                guard let after = self.hotPostsAfter else { return }
                
                guard !self.isRetrievingHotPosts else { return }
                self.isRetrievingHotPosts = true
                
                let posts = try await self.networkService.getHotPosts(after: after)
                let mappedPosts = self.modelMapper.map(from: posts)
                self.hotPosts.append(contentsOf: mappedPosts)
                self.hotPostsAfter = posts.data.after
                
                self.isRetrievingHotPosts = false
                self.input?.onHotPostsUpdated()
            } catch {
                self.isRetrievingHotPosts = false
                //Это не bad practice если тебе было весело
                print(error)
                fatalError()
            }
        }
    }
}
