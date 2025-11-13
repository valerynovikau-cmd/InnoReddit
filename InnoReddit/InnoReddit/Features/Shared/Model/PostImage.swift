//
//  PostImage.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct PostImage: Identifiable {
    let id: String
    let fullUrl: String?
    let fullWidth: Int?
    let fullHeight: Int?
    let previewUrl: String?
    let previewWidth: Int?
    let previewHeight: Int?
}
