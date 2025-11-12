//
//  PostImage.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

#warning("почитать почему без этого ошибка")
nonisolated
struct PostImage: Hashable, Sendable {
    let id: String
    let fullUrl: String?
    let fullWidth: Int?
    let fullHeight: Int?
    let previewUrl: String?
    let previewWidth: Int?
    let previewHeight: Int?

    static func == (lhs: PostImage, rhs: PostImage) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
