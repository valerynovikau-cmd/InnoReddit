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
                var previewSource: PostImageSource?
                var fullSource: PostImageSource?
                
                if let previewsCount = image.resolutions?.sorted(by: {
                    $0.height ?? 0 < $1.height ?? 1
                }).count,
                   previewsCount > 0
                {
                    let previewImage = image.resolutions![previewsCount / 2]
                    if let previewUrl = previewImage.url,
                       let previewWidth = previewImage.width,
                       let previewHeight = previewImage.height
                    {
                        previewSource = PostImageSource(
                            url: previewUrl,
                            width: previewWidth,
                            height: previewHeight
                        )
                    }
                }
                
                if let fullUrl = image.source?.url,
                   let fullWidth = image.source?.width,
                   let fullHeight = image.source?.height
                {
                    fullSource = PostImageSource(
                        url: fullUrl,
                        width: fullWidth,
                        height: fullHeight
                    )
                }
                
                guard fullSource != nil || previewSource != nil else { return nil }
                
                return PostImage(
                    id: image.id,
                    fullSource: fullSource,
                    previewSource: previewSource
                )
            }) ?? []
            
            let multipleImages: [PostImage] = data.mediaMetadata?.values.compactMap { (multipleMediaResponseDTO) -> PostImage? in
                guard let previews = multipleMediaResponseDTO.p,
                      let id = multipleMediaResponseDTO.id,
                      multipleMediaResponseDTO.e == "Image"
                else { return nil }
                
                var previewSource: PostImageSource?
                var fullSource: PostImageSource?
                
                if previews.count > 0,
                   let previewImage = previews.last,
                   let previewUrl = previewImage.u,
                   let previewHeight = previewImage.y,
                   let previewWidth = previewImage.x
                {
                    previewSource = PostImageSource(
                        url: previewUrl,
                        width: previewWidth,
                        height: previewHeight
                    )
                }
                
                if let fullImage = multipleMediaResponseDTO.s,
                   let fullUrl = fullImage.u,
                   let fullWidth = fullImage.x,
                   let fullHeight = fullImage.y {
                    fullSource = PostImageSource(
                        url: fullUrl,
                        width: fullWidth,
                        height: fullHeight
                    )
                }
                
                guard fullSource != nil || previewSource != nil else { return nil }
                
                return PostImage(
                    id: id,
                    fullSource: fullSource,
                    previewSource: previewSource
                )
            } ?? []
            
            let images: [PostImage] = singleImages + multipleImages
            
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
                images: images.isEmpty ? nil : images,
                subredditId: data.subredditId,
                id: data.name,
                authorName: data.author,
                commentsCount: data.numComments
            )
        })
        return posts
    }
}
