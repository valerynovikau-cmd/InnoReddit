//
//  PostsPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import Factory

final class PostsPresenter {
    weak var input: PostsViewProtocol?
    @Injected(\.mainFeedNetworkService) private var networkService: MainFeedNetworkServiceProtocol
    @Injected(\.mainFeedModelMapper) private var modelMapper: MainFeedModelMapperProtocol
    
    private(set) var posts: [Post] = []
    private(set) var postsAfter: String?
    private(set) var isRetrievingPosts: Bool = false
    private let category: MainFeedCategory
    
    init (category: MainFeedCategory) {
        self.category = category
    }
}

extension PostsPresenter: PostsPresenterProtocol {
    func preformPostsRetrieval() {
        Task {
            do {
                guard !self.isRetrievingPosts else { return }
                self.isRetrievingPosts = true
                
                let posts = try await self.networkService.getPosts(after: nil, category: self.category)
                let mappedPosts = self.modelMapper.map(from: posts)
                self.posts = mappedPosts
                self.postsAfter = posts.data.after
                
                self.isRetrievingPosts = false
                self.input?.onPostsUpdated()
            } catch {
                self.isRetrievingPosts = false
                //Это не bad practice если тебе было весело
                print(error)
                fatalError()
            }
        }
    }
    
    func performPostsPaginatedRetrieval() {
        Task {
            do {
                guard let after = self.postsAfter else { return }
                
                guard !self.isRetrievingPosts else { return }
                self.isRetrievingPosts = true
                
                let posts = try await self.networkService.getPosts(after: after, category: self.category)
                let mappedPosts = self.modelMapper.map(from: posts)
                self.posts.append(contentsOf: mappedPosts)
                self.postsAfter = posts.data.after
                
                self.isRetrievingPosts = false
                self.input?.onPostsUpdated()
            } catch {
                self.isRetrievingPosts = false
                //Это не bad practice если тебе было весело
                print(error)
                fatalError()
            }
        }
    }
}
