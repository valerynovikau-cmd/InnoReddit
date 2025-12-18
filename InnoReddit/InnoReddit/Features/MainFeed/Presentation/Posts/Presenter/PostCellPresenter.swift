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
    var postSeparatedText: String? { get }
    
    func onPostTap()
    func onUpvoteTap()
    func onDownvoteTap()
    func onCommentTap()
    func onBookmarkTap()
    func onSubredditTap()
    
    func retrieveSubredditIconURL()
    func updatePost()
}

final class PostCellPresenter {
    weak var input: PostCellProtocol?
    var router: MainScreenRouterProtocol?
    
    @Injected(\.postsNetworkService) private var networkService: PostsNetworkServiceProtocol
    @Injected(\.subredditIconsMemoryCache) private var cache: SubredditIconsMemoryCache
    
    private(set) var post: Post
    private(set) var postSeparatedText: String?
    
    init(post: Post) {
        self.post = post
        if self.post.images != nil && !self.post.images!.isEmpty ||
            self.post.videos != nil && !self.post.videos!.isEmpty
        {
            let separatedContent = PostTextDataSeparator.separatePostContents(post: post)
            self.postSeparatedText = separatedContent.compactMap({ content in
                switch content {
                case .text(let text):
                    return text
                default:
                    return nil
                }
            }).joined(separator: " ")
        } else {
            self.postSeparatedText = self.post.text
        }
    }
}

extension PostCellPresenter: PostCellPresenterProtocol {
    func retrieveSubredditIconURL() {
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
    
    func updatePost() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let post = try await self.networkService.updatePost(postName: self.post.id)
                self.post.commentsCount = post.numComments
                self.post.score = post.score
                self.post.votedUp = post.likes
                self.input?.onScoreAndCommentsCountUpdated()
            }
        }
    }
    
    private func shouldSetIcon(subredditIconURL: String?, subreddit: String?, shouldAnimate: Bool = false) {
        guard subreddit == self.post.subreddit else { return }
        self.input?.onSubredditIconURLRetrieved(subredditIconURL: subredditIconURL, shouldAnimate: shouldAnimate)
    }
    
    func onPostTap() {
        self.router?.showPostDetails(post: post)
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
