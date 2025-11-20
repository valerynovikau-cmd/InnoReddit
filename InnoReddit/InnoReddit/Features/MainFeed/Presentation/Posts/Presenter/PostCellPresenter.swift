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
    @Injected(\.subredditIconsMemoryCache) private var cache: SubredditIconsMemoryCache
    
    private(set) var post: Post
    
    init(post: Post) {
        self.post = post
    }
}

extension PostCellPresenter: PostCellPresenterProtocol {
    func retrieveSubredditIconURL() {
        Task { [weak self] in
            guard let self else { return }
            
            guard let subreddit = post.subreddit else {
                self.shouldSetIcon(subredditIconURL: nil, subreddit: nil)
                return
            }
            
            if let url = await cache.getItem(key: subreddit) {
                self.shouldSetIcon(subredditIconURL: url, subreddit: subreddit)
                return
            }
            
            var iconURL: String?
            do {
                let response = try await self.networkService.getSubredditIconURL(subredditName: subreddit)
                iconURL = response.data.iconImg
                if let iconURL {
                    await cache.setItem(key: subreddit, value: iconURL)
                    self.shouldSetIcon(subredditIconURL: iconURL, subreddit: subreddit, shouldAnimate: true)
                } else {
                    self.shouldSetIcon(subredditIconURL: nil, subreddit: subreddit)
                }
            } catch { }
        }
    }
    
    private func shouldSetIcon(subredditIconURL: String?, subreddit: String?, shouldAnimate: Bool = false) {
        guard subreddit == self.post.subreddit else { return }
        self.input?.onSubredditIconURLRetrieved(subredditIconURL: subredditIconURL, shouldAnimate: shouldAnimate)
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
