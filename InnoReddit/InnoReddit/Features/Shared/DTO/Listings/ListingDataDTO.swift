//
//  ListingDataDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

struct ListingDataDTO: Decodable {
    let before: String?
    let after: String?
    let children: [ListingChildDTO]
}
