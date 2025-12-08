//
//  RequestBody.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

enum RequestBody {
    case jsonBody(Encodable)
    case urlEncodedBody([String: String])
}
