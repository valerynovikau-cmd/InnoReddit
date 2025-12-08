//
//  PostDetailsStore.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.12.25.
//

import Combine
import Foundation

protocol PostDetailsStoreProtocol: AnyObject {
    func configure(post: Post)
    func onSubredditIconUpdated()
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
    
    func onSubredditIconUpdated() {
        
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
