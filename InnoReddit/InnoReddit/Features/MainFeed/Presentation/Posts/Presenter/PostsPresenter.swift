//
//  PostsPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import Factory

protocol PostsPresenterProtocol: AnyObject {
    var input: PostsViewProtocol? { get set }
    var isRetrievingPosts: Bool { get }
    
    var posts: [Post] { get }
    var postsAfter: String? { get }
    
    func preformPostsRetrieval()
    func performPostsPaginatedRetrieval()
}

final class PostsPresenter {
    weak var input: PostsViewProtocol?
    @Injected(\.postsNetworkService) private var networkService: PostsNetworkServiceProtocol
    @Injected(\.postsModelMapper) private var modelMapper: PostsModelMapperProtocol
    
    private(set) var posts: [Post] = []
    private(set) var postsAfter: String?
    private(set) var isRetrievingPosts: Bool = false
    private let category: MainFeedCategory
    private var seenPostsIDs: Set<String> = []
    
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
                
                let uniquePosts = mappedPosts.filter { post in
                    if self.seenPostsIDs.contains(post.id) {
                        return false
                    } else {
                        self.seenPostsIDs.insert(post.id)
                        return true
                    }
                }
                self.posts = uniquePosts
                
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
                
                let uniquePosts = mappedPosts.filter { post in
                    if self.seenPostsIDs.contains(post.id) {
                        return false
                    } else {
                        self.seenPostsIDs.insert(post.id)
                        return true
                    }
                }
                self.posts.append(contentsOf: uniquePosts)
    
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
