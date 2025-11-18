//
//  ListingResponseDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct ListingResponseDTO: Decodable {
    let kind: String
    let data: ListingDataResponseDTO
}
