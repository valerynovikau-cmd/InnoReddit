//
//  UserMeInfoDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 24.12.25.
//

import Foundation

struct UserMeInfoDTO: Decodable {
    let name: String
    let iconImg: String
    let totalKarma: Int
    let created: Double
    let subreddit: UserMeSubredditDTO
}
