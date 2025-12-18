//
//  RedditVideoDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 16.12.25.
//

struct RedditVideoDTO: Decodable {
    let id: String?
    let hlsUrl: String
    let isGif: Bool
    let height: Int
    let width: Int
}
