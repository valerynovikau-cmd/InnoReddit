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
    let score: Int
    let created: Date
    let images: [PostImage]?
    let subredditId: String
    let id: String
    let authorName: String
    let commentsCount: Int
}
