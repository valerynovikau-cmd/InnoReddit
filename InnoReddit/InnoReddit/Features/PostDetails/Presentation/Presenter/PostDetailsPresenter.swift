//
//  PostDetailsPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.12.25.
//

import Factory

protocol PostDetailsPresenterProtocol: AnyObject {
    var input: PostDetailsStoreProtocol? { get set }
    
    var post: Post { get }
    
    func retrieveSubbreditImage()
    
    func onBookmarkTap()
    func onUpvoteTap()
    func onDownvoteTap()
    func onMoreTap()
}

final class PostDetailsPresenter {
    @Injected(\.subredditIconsMemoryCache) private var cache: SubredditIconsMemoryCache
    @Injected(\.postDetailsNetworkService) private var networkService: PostDetailsNetworkServiceProtocol
    
    weak var input: PostDetailsStoreProtocol? {
        didSet {
            input?.configure(post: self.post)
        }
    }
    
    private(set) var post: Post
    
    init(post: Post) {
        self.post = post
    }
}

extension PostDetailsPresenter: PostDetailsPresenterProtocol {
    func retrieveSubbreditImage() {
        guard let subreddit = post.subreddit else {
            self.shouldSetIcon(subredditIconURL: nil, subreddit: nil)
            return
        }
        Task { [weak self, subreddit] in
            guard let self else { return }
            
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
            } catch {
                self.shouldSetIcon(subredditIconURL: nil, subreddit: subreddit)
            }
        }
    }
    
    private func shouldSetIcon(subredditIconURL: String?, subreddit: String?, shouldAnimate: Bool = false) {
        guard subreddit == self.post.subreddit else { return }
        self.input?.onSubredditIconUpdated(iconURL: subredditIconURL, shouldAnimate: shouldAnimate)
    }
    
    func onBookmarkTap() {
        input?.onBookmarkTap()
    }
    
    func onUpvoteTap() {
        input?.onUpvoteTap()
    }
    
    func onDownvoteTap() {
        input?.onDownvoteTap()
    }
    
    func onMoreTap() {
        input?.onMoreTap()
    }
}
