//
//  ProfilePostsPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 23.12.25.
//

import Factory
import Foundation

final class ProfilePostsPresenter {
    weak var input: PostsViewProtocol?
    var router: MainScreenRouterProtocol?
    
    @Injected(\.profilePostsNetworkService) private var networkService: ProfilePostsNetworkServiceProtocol
    @Injected(\.postsModelMapper) private var modelMapper: PostsModelMapperProtocol
    
    private(set) var posts: [Post] = []
    private(set) var postsAfter: String?
    private(set) var isRetrievingPosts: Bool = false
    private let category: ProfilePostsCategory
    private var seenPostsIDs: Set<String> = []
    private var seenSubredditIconsURL: [String:String] = [:]
    
    init (category: ProfilePostsCategory) {
        self.category = category
    }
}

extension ProfilePostsPresenter: PostsPresenterProtocol {
    
    func didSelectPost(post: Post) {
        self.router?.showPostDetails(post: post)
    }
    
    func updatePost(post: Post) {
        guard let index = self.posts.firstIndex(where: { oldPost in
            oldPost.id == post.id
        })
        else { return }
        self.posts[index] = post
    }
    
    func performPostsRetrieval() {
        Task { [weak self] in
            guard let self else { return }
            do {
                guard !self.isRetrievingPosts else { return }
                self.isRetrievingPosts = true
                
                self.seenPostsIDs = []
                
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
                self.input?.onLoadingFinished()
                self.input?.onPostsUpdated()
            } catch {
                self.errorHandling(error: error)
            }
        }
    }
    
    func performPostsPaginatedRetrieval() {
        Task { [weak self] in
            guard let self else { return }
            do {
                guard let after = self.postsAfter else { return }
                
                guard !self.isRetrievingPosts else { return }
                self.isRetrievingPosts = true
                self.input?.onLoadingStarted()
                
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
                self.input?.onLoadingFinished()
                self.input?.onPostsUpdated()
            } catch {
                self.errorHandling(error: error)
            }
        }
    }
    
    private func errorHandling(error: Error) {
        self.isRetrievingPosts = false
        self.input?.onLoadingFinished()
        var errorTitle: String?
        var errorMessage: String?
        if let apiError = error as? APIError {
            errorTitle = apiError.errorTitle
            errorMessage = apiError.errorMessage
        }
        self.input?.showAlert(title: errorTitle, message: errorMessage)
    }
}
