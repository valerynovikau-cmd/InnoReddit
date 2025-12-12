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
    func onBookmarkTap()
    func onUpvoteTap()
    func onDownvoteTap()
    func onMoreTap()
}

final class PostDetailsStore: ObservableObject {
    private lazy var dateFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .numeric
        return formatter
    }()
    
    var output: PostDetailsPresenterProtocol?
    
    @Published var title: String?
    @Published var content: [PostTextContentType] = []
    @Published var date: String = ""
    @Published var subredditName: String?
    @Published var authorName: String?
    @Published var score: String = ""

    enum SubredditIconToShow {
        case defaultIcon
        case iconFromURL(URL)
    }
    @Published var iconToShow: SubredditIconToShow?
    
    @Published var images: [PostImage]? = nil
}

extension PostDetailsStore: PostDetailsStoreProtocol {
    func configure(post: Post, postContent: [PostTextContentType]) {
        self.title = post.title
        self.date = dateFormatter.localizedString(for: post.created, relativeTo: Date())
        self.score = "\(post.score)"
        self.subredditName = post.subreddit
        self.authorName = post.authorName
        self.images = post.images
        
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
    
    func onBookmarkTap() {
        
    }
    
    func onUpvoteTap() {
        
    }
    
    func onDownvoteTap() {
        
    }
    
    func onMoreTap() {
        
    }
}
