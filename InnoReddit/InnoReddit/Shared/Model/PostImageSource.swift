//
//  PostImageSource.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 9.12.25.
//

struct PostImageSource {
    let url: String
    let width: Int
    let height: Int
}

extension PostImageSource: Hashable { }
