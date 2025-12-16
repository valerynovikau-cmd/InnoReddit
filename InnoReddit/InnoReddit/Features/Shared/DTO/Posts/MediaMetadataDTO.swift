//
//  MediaMetadataDTO.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 19.11.25.
//

struct MediaMetadataDTO: Decodable {
    let e: String?
    
    let m: String?
    let p: [MediaMetadataImageSourceDTO]?
    let s: MediaMetadataImageSourceDTO?
    
    let dashUrl: String?
    let x: Int?
    let y: Int?
    let hlsUrl: String?
    let isGif: Bool?
    
    let id: String?
}
