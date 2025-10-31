//
//  TokenRetrievalDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

struct TokenRetrievalDTO: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let refreshToken: String?
}
