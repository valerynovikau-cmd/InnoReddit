//
//  ListingDataResponseDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct ListingDataResponseDTO: Decodable {
    let before: String?
    let after: String?
    let children: [ListingChildResponseDTO]
}
