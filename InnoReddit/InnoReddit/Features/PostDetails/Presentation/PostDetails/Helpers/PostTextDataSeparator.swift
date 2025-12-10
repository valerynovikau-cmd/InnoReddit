//
//  PostTextDataSeparator.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 10.12.25.
//

import Foundation

struct PostTextDataSeparator {
    static func separatePostContents(post: Post) -> [PostTextContentType] {
        guard let postText = post.text else {
            return []
        }
        var postImages = post.images ?? []
        
        return self.recursiveContentSeparator(content: [.text(postText)], postImages: &postImages)
    }
    
    private static func recursiveContentSeparator(content: [PostTextContentType], postImages: inout [PostImage]) -> [PostTextContentType] {
        var result: [PostTextContentType] = []
        guard !postImages.isEmpty else {
            return content
        }
        result = content.flatMap { item -> [PostTextContentType] in
            switch item {
            case .text(let text):
                if let splittedText = self.separateText(text: text, postImages: &postImages) {
                    return self.recursiveContentSeparator(content: splittedText, postImages: &postImages)
                } else {
                    return [item]
                }
            case .image(let postImage):
                return [item]
            }
        }
        return result
    }
    
    private static func separateText(text: String, postImages: inout [PostImage]) -> [PostTextContentType]? {
        guard let imageToFind = postImages.first else {
            return nil
        }
        
        guard let imageUrl = imageToFind.fullSource?.url ?? imageToFind.previewSource?.url else {
            postImages.removeFirst()
            return nil
        }
        
        if let range = text.range(of: imageUrl) {
            var result: [PostTextContentType] = []
            let before = String(text[..<range.lowerBound])
            let after = String(text[range.upperBound...])
            
            if !before.isEmpty {
                result.append(.text(before))
            }
            
            result.append(.image(imageToFind))
            
            if !after.isEmpty {
                result.append(.text(after))
            }
            
            postImages.removeFirst()
            return result
        } else {
            return nil
        }
    }
}
