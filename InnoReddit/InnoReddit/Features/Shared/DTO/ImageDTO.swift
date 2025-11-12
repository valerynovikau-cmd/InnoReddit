//
//  ImageDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct ImageDTO: Decodable {
    let source: ImageSourceDTO?
    let resolutions: [ImageSourceDTO]?
    let id: String
}
