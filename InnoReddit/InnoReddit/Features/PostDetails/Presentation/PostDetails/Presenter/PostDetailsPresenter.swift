//
//  PostDetailsPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.12.25.
//

import Factory
import Foundation

protocol PostDetailsPresenterProtocol: AnyObject {
    var input: PostDetailsStoreProtocol? { get set }
    
    var post: Post { get }
    
    func retrieveSubbreditImage()
    
    func onBookmarkTap(state: PostDetailsSaveState)
    func onUpvoteTap(state: PostDetailsScoreState)
    func onDownvoteTap(state: PostDetailsScoreState)
    func onMoreTap()
}

final class PostDetailsPresenter {
    @Injected(\.subredditIconsMemoryCache) private var cache: SubredditIconsMemoryCache
    @Injected(\.postDetailsNetworkService) private var networkService: PostDetailsNetworkServiceProtocol
    
    weak var input: PostDetailsStoreProtocol? {
        didSet {
            let postContent = PostTextDataSeparator.separatePostContents(post: self.post)
            input?.configure(post: self.post, postContent: postContent)
        }
    }
    
    private(set) var post: Post
    private var isModifyingScore: Bool = false
    private var isModifyingSave: Bool = false
    
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
    
    func onBookmarkTap(state: PostDetailsSaveState) {
        guard !isModifyingSave else { return }
        isModifyingSave = true
        self.input?.setSaveIsChanging()
        Task { [weak self] in
            guard let self else { return }
            do {
                var newState: PostDetailsSaveState
                if state == .saved {
                    newState = .none
                    try await self.networkService.unsavePost(postId: self.post.id)
                } else {
                    newState = .saved
                    try await self.networkService.savePost(postId: self.post.id)
                }
                self.input?.changeSaveState(newState: newState)
            } catch { }
            self.isModifyingSave = false
        }
    }
    
    func onUpvoteTap(state: PostDetailsScoreState) {
        guard !isModifyingScore else { return }
        isModifyingScore = true
        self.input?.setScoreIsChanging()
        Task { [weak self] in
            guard let self else { return }
            do {
                var vote: ScoreDirection
                var newState: PostDetailsScoreState
                if state == .upVoted {
                    vote = .none
                    newState = .none
                } else {
                    vote = .up
                    newState = .upVoted
                }
                try await self.networkService.sendVote(vote: vote, id: self.post.id)
                self.input?.changeScoreState(newState: newState)
            } catch { }
            self.isModifyingScore = false
        }
    }
    
    func onDownvoteTap(state: PostDetailsScoreState) {
        guard !isModifyingScore else { return }
        isModifyingScore = true
        self.input?.setScoreIsChanging()
        Task { [weak self] in
            guard let self else { return }
            do {
                var vote: ScoreDirection
                var newState: PostDetailsScoreState
                if state == .downVoted {
                    vote = .none
                    newState = .none
                } else {
                    vote = .down
                    newState = .downVoted
                }
                try await self.networkService.sendVote(vote: vote, id: self.post.id)
                self.input?.changeScoreState(newState: newState)
            } catch { }
            self.isModifyingScore = false
        }
    }
    
    func onMoreTap() {
        input?.onMore()
    }
}
