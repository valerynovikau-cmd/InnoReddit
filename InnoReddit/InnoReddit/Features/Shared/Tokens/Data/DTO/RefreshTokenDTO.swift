//
//  RefreshTokenDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 10.11.25.
//

struct RefreshTokenDTO: Encodable {
    let grantType: String
    let refreshToken: String
}
