//
//  PostDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct PostDTO: Decodable {
    let subreddit: String
    let selftext: String?
    let authorFullname: String?
    let saved: Bool
    let title: String?
    let downs: Int
    let name: String
    let ups: Int
    let score: Int
    let created: Double
    let likes: Bool?
    let preview: PreviewDTO?
    let mediaMetadata: [String: MediaMetadataDTO]?
    let subredditId: String
    let id: String
    let author: String?
    let numComments: Int
    let media: MediaDTO?
    let isVideo: Bool
}
