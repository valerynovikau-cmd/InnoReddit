//
//  PostCellPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 18.11.25.
//

import Factory

protocol PostCellPresenterProtocol: AnyObject {
    var input: PostCellProtocol? { get set }
    var router: MainScreenRouterProtocol? { get set }
    
    var post: Post { get }
    
    func onPostTap()
    func onUpvoteTap()
    func onDownvoteTap()
    func onCommentTap()
    func onBookmarkTap()
    func onSubredditTap()
    
    func retrieveSubredditIconURL()
}

final class PostCellPresenter {
    weak var input: PostCellProtocol?
    var router: MainScreenRouterProtocol?
    @Injected(\.postsNetworkService) private var networkService: PostsNetworkServiceProtocol
    
    private(set) var post: Post
    
    init(post: Post) {
        self.post = post
    }
}

extension PostCellPresenter: PostCellPresenterProtocol {
    func retrieveSubredditIconURL() {
        Task { [weak self] in
            guard let self, let subreddit = post.subreddit else { return }
            var iconURL: String?
            do {
                let response = try await self.networkService.getSubredditIconURL(subredditName: subreddit)
                iconURL = response.data.iconImg
            } catch {
                
            }
            self.input?.onSubredditIconURLRetrieved(subredditIconURL: iconURL)
        }
    }
    
    func onPostTap() {
        
    }
    
    func onUpvoteTap() {
        
    }
    
    func onDownvoteTap() {
        
    }
    
    func onCommentTap() {
        
    }
    
    func onBookmarkTap() {
        
    }
    
    func onSubredditTap() {
        
    }
}
