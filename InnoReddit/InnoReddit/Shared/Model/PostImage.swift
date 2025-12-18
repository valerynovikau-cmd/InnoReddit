//
//  PostImage.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct PostImage: Identifiable {
    let id: String
    let fullSource: PostImageSource?
    let previewSource: PostImageSource?
}

extension PostImage: Hashable { }
