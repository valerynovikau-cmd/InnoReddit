//
//  PostVideo.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 15.12.25.
//

struct PostVideo: Identifiable {
    let id: String
    let hlsUrl: String
    let height: Int
    let width: Int
}

extension PostVideo: Hashable { }
