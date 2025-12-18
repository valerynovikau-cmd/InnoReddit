//
//  PostTextContentType.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 10.12.25.
//

enum PostTextContentType: Equatable, Hashable, Identifiable {
    var id: Self { self }
    case text(String)
    case image(PostImage)
    case video(PostVideo)
}
