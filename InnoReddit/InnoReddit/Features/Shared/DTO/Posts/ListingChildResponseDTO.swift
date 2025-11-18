//
//  ListingChildResponseDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct ListingChildResponseDTO: Decodable {
    let kind: String
    let data: PostResponseDTO
}
