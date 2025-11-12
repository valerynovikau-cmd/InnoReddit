//
//  Post.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import Foundation

#warning("почитать почему без этого ошибка")
nonisolated
struct Post: Hashable, Sendable {
    let subreddit: String?
    let text: String?
    let authorId: String?
    let saved: Bool
    let title: String?
    let downs: Int
    let ups: Int
    let score: Int
    let created: Date
    let images: [PostImage]?
    let subredditId: String
    let id: String
    let authorName: String
    let commentsCount: Int
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
