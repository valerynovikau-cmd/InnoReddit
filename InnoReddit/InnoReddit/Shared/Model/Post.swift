//
//  Post.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import Foundation

struct Post: Identifiable {
    let subreddit: String?
    let text: String?
    let authorId: String?
    let saved: Bool
    let title: String?
    let downs: Int
    let ups: Int
    var score: Int
    let created: Date
    let images: [PostImage]?
    let videos: [PostVideo]?
    let subredditId: String
    let id: String
    let authorName: String?
    var commentsCount: Int
    var votedUp: Bool?
}

extension Post: Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id &&
        lhs.commentsCount == rhs.commentsCount &&
        lhs.score == rhs.score
    }
}
