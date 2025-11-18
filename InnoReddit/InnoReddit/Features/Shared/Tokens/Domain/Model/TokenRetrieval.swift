//
//  TokenRetrieval.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

struct TokenRetrieval {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: [AuthScopes]
    let refreshToken: String?
}
