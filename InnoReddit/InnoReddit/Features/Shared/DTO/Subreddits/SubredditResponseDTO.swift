//
//  SubredditResponseDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 18.11.25.
//

struct SubredditResponseDTO: Decodable {
    let kind: String
    let data: SubredditAboutDTO
}
