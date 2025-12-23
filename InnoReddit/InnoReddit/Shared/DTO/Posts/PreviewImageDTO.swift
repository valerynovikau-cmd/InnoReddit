//
//  PreviewImageDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct PreviewImageDTO: Decodable {
    let source: PreviewImageSourceDTO?
    let resolutions: [PreviewImageSourceDTO]?
    let id: String
}
