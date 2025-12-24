//
//  UserModel.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 24.12.25.
//

import Foundation

struct UserModel: Codable {
    let username: String
    let iconImageURL: String
    let totalKarma: Int
    let accountCreatedAt: Date
    let subscribers: Int
}
