//
//  SingleImagesDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct SingleImagesDTO: Decodable {
    let source: SingleImageSourceDTO?
    let resolutions: [SingleImageSourceDTO]?
    let id: String
}
