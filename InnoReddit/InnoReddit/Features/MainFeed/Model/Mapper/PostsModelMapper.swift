//
//  PostsModelMapper.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import Foundation

protocol PostsModelMapperProtocol {
    func map(from: ListingResponseDTO) -> [Post]
}

final class PostsModelMapper: PostsModelMapperProtocol {
    func map(from modelToMap: ListingResponseDTO) -> [Post] {
        let posts = modelToMap.data.children.compactMap({ child in
            let data = child.data
            let date = Date(timeIntervalSince1970: TimeInterval(floatLiteral: data.created))
            let singleImages: [PostImage] = data.preview?.images?.compactMap({ image in
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
            }) ?? []
            
            let multipleImages: [PostImage] = data.mediaMetadata?.values.compactMap { (multipleMediaResponseDTO) -> PostImage? in
                guard let previews = multipleMediaResponseDTO.p,
                      let id = multipleMediaResponseDTO.id,
                      multipleMediaResponseDTO.e == "Image"
                else { return nil }
                
                var previewUrl: String?
                var previewHeight: Int?
                var previewWidth: Int?
                
                if previews.count > 0 {
                    let previewImage = previews.last
                    previewUrl = previewImage?.u
                    previewHeight = previewImage?.y
                    previewWidth = previewImage?.x
                }
                
                return PostImage(
                    id: id,
                    fullUrl: multipleMediaResponseDTO.s?.u,
                    fullWidth: multipleMediaResponseDTO.s?.x,
                    fullHeight: multipleMediaResponseDTO.s?.y,
                    previewUrl: previewUrl,
                    previewWidth: previewWidth,
                    previewHeight: previewHeight
                )
            } ?? []
            
            let images: [PostImage]? = singleImages + multipleImages
            
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
