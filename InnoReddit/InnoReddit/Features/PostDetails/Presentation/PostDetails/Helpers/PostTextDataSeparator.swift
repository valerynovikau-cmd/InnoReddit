//
//  PostTextDataSeparator.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 10.12.25.
//

import Foundation

struct PostTextDataSeparator {
    private struct PostContents {
        var images: [PostImage]
        var videos: [PostVideo]
        
        init(images: [PostImage], videos: [PostVideo]) {
            self.images = images
            self.videos = videos
        }
    }
    
    static func separatePostContents(post: Post) -> [PostTextContentType] {
        guard let postText = post.text else {
            return []
        }
        let postToHandle = PostContents(
            images: post.images ?? [],
            videos: post.videos ?? []
        )
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(
                in: postText,
                range: NSRange(postText.startIndex..., in: postText)
            )
            
            if matches.isEmpty {
                return [.text(postText)]
            }
            
            var result: [PostTextContentType] = []
            var currentIndex = postText.startIndex
            
            for match in matches {
                guard let range = Range(match.range, in: postText),
                      let url = match.url
                else { continue }
                
                if currentIndex < range.lowerBound {
                    var beforeSubstring = String(postText[currentIndex..<range.lowerBound])
                    if !beforeSubstring.isEmpty {
                        if beforeSubstring.hasPrefix("\n\n") {
                            beforeSubstring.removeSubrange(beforeSubstring.startIndex..<beforeSubstring.index(beforeSubstring.startIndex, offsetBy: 2))
                        }
                        if beforeSubstring.hasSuffix("\n\n") {
                            beforeSubstring.removeSubrange(beforeSubstring.index(beforeSubstring.endIndex, offsetBy: -2)..<beforeSubstring.endIndex)
                        }
                        if !beforeSubstring.isEmpty {
                            result.append(.text(beforeSubstring))
                        }
                    }
                }
                
                if let firstImage = postToHandle.images.first(where: { image in
                    image.fullSource?.url == url.absoluteString
                }) {
                    result.append(.image(firstImage))
                    currentIndex = range.upperBound
                    continue
                }
                
                if let firstVideo = postToHandle.videos.first(where: { video in
                    url.absoluteString.range(of: video.id) != nil
                }) {
                    result.append(.video(firstVideo))
                    currentIndex = range.upperBound
                    continue
                }
            }
            
            if currentIndex < postText.endIndex {
                var afterSubstring = String(postText[currentIndex...])
                if afterSubstring.hasPrefix("\n\n") {
                    afterSubstring.removeSubrange(afterSubstring.startIndex..<afterSubstring.index(afterSubstring.startIndex, offsetBy: 2))
                }
                if !afterSubstring.isEmpty {
                    result.append(.text(afterSubstring))
                }
            }
            
            return result
        } catch {
            return [.text(postText)]
        }
    }
}
