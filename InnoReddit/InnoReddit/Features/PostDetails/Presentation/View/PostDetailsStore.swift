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
    func configure(post: Post)
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
    
    @Published var title: String?
    @Published var text: String?
    @Published var date: String = ""
    @Published var subredditName: String?
    @Published var authorName: String?
    @Published var score: String = ""

    enum SubredditIconToShow {
        case defaultIcon
        case nonDefaultIcon(String)
    }
    @Published var iconToShow: SubredditIconToShow?
}

extension PostDetailsStore: PostDetailsStoreProtocol {
    func configure(post: Post) {
        self.title = post.title
        self.text = post.text
        self.date = dateFormatter.localizedString(for: post.created, relativeTo: Date())
        self.score = "\(post.score)"
        self.subredditName = post.subreddit
        self.authorName = post.authorName
    }
    
    func onSubredditIconUpdated(iconURL: String?, shouldAnimate: Bool) {
        var iconToShow: SubredditIconToShow
        if let iconURL, !iconURL.isEmpty {
            iconToShow = .nonDefaultIcon(iconURL)
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
