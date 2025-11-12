//
//  MainFeedModelMapper.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import Foundation

protocol MainFeedModelMapperProtocol {
    func map(from: ListingResponseDTO) -> [Post]
}

final class MainFeedModelMapper: MainFeedModelMapperProtocol {
    func map(from modelToMap: ListingResponseDTO) -> [Post] {
        let posts = modelToMap.data.children.compactMap({ child in
            let data = child.data
#warning("поменять")
            let date = Date()
            let images: [PostImage]? = data.preview?.images?.compactMap({ image in
                var previewUrl: String?
                var previewHeight: Int?
                var previewWidth: Int?
                
                if let previewsCount = image.resolutions?.sorted(by: { $0.height < $1.height }).count,
                   previewsCount > 0
                {
                    let previewImage = image.resolutions![previewsCount / 2]
                    previewUrl = previewImage.url
                    previewHeight = previewImage.height
                    previewWidth = previewImage.width
                }
                
                return PostImage(
                    id: image.id,
                    fullUrl: image.source?.url,
                    fullWidth: image.source?.width,
                    fullHeight: image.source?.height,
                    previewUrl: previewUrl,
                    previewWidth: previewWidth,
                    previewHeight: previewHeight
                )
            })
            
            return Post(
                subreddit: data.subreddit,
                text: data.selftext,
                authorId: data.authorFullname,
                saved: data.saved,
                title: data.title,
                downs: data.downs,
                ups: data.ups,
                score: data.score,
                created: date,
                images: images,
                subredditId: data.subredditId,
                id: data.name,
                authorName: data.author,
                commentsCount: data.numComments
            )
        })
        return posts
    }
}
