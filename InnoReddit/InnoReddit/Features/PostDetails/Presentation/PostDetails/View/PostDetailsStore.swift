//
//  PostDetailsStore.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.12.25.
//

import Combine
import Foundation
import SwiftUI

protocol PostDetailsStoreProtocol: AnyObject {
    var output: PostDetailsPresenterProtocol? { get set }
    func configure(post: Post, postContent: [PostTextContentType])
    func onSubredditIconUpdated(iconURL: String?, shouldAnimate: Bool)
    func onBookmark()
    func changeScoreState(newState: PostDetailsScoreState)
    func setScoreIsChanging()
    func onMore()
}

enum PostDetailsScoreState: Int {
    case upVoted = 1
    case downVoted = -1
    case none = 0
}

enum PostDetailsSaveState {
    case modifyingSave
    case saved
    case none
}

enum SubredditIconToShow {
    case defaultIcon
    case iconFromURL(URL)
}

final class PostDetailsStore: ObservableObject {
    private lazy var dateFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .numeric
        return formatter
    }()
    
    var output: PostDetailsPresenterProtocol?
    
    private let fadeDuration: TimeInterval = 0.1
    
    @Published var title: String?
    @Published var content: [PostTextContentType] = []
    @Published var date: String = ""
    @Published var subredditName: String?
    @Published var authorName: String?
    @Published var score: String = ""
    
    @Published private(set) var scoreState: PostDetailsScoreState = .none
    @Published private(set) var isModifyingScore: Bool = false
    @Published private(set) var saveState: PostDetailsSaveState = .none
    
    @Published var iconToShow: SubredditIconToShow?
    
    @Published var images: [PostImage]? = nil
    @Published var videos: [PostVideo]? = nil
}

extension PostDetailsStore: PostDetailsStoreProtocol {
    func configure(post: Post, postContent: [PostTextContentType]) {
        self.title = post.title
        self.date = dateFormatter.localizedString(for: post.created, relativeTo: Date())
        self.score = "\(post.score)"
        self.subredditName = post.subreddit
        self.authorName = post.authorName
        self.images = post.images
        self.videos = post.videos
        
        switch post.votedUp {
        case true:
            self.scoreState = .upVoted
        case false:
            self.scoreState = .downVoted
        case nil:
            self.scoreState = .none
        }
        
        self.content = postContent
    }
    
    func onSubredditIconUpdated(iconURL: String?, shouldAnimate: Bool) {
        var iconToShow: SubredditIconToShow
        if let iconURL,
           !iconURL.isEmpty,
           let url = URL(string: iconURL)
        {
            iconToShow = .iconFromURL(url)
        } else {
            iconToShow = .defaultIcon
        }
        
        if shouldAnimate {
            withAnimation {
                self.iconToShow = iconToShow
            }
        } else {
            self.iconToShow = iconToShow
        }
    }
    
    func setScoreIsChanging() {
        withAnimation(.easeIn(duration: fadeDuration)) {
            self.isModifyingScore = true
        }
    }
    
    func onBookmark() {
        
    }
    
    func changeScoreState(newState: PostDetailsScoreState) {
        withAnimation(.easeIn(duration: fadeDuration)) {
            self.scoreState = newState
            self.isModifyingScore = false
            self.score = "\((output?.post.score ?? 0) + newState.rawValue)"
        }
    }
    
    func onMore() {
        
    }
}
