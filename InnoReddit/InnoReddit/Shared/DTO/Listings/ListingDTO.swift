//
//  ListingDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct ListingDTO: Decodable {
    let kind: String
    let data: ListingDataDTO
}
