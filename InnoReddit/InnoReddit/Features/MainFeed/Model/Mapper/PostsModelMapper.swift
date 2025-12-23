//
//  PostsModelMapper.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import Foundation

protocol PostsModelMapperProtocol {
    func map(from: ListingDTO) -> [Post]
}

final class PostsModelMapper: PostsModelMapperProtocol {
    private struct MultipleMedia {
        var images: [PostImage] = []
        var videos: [PostVideo] = []
    }
    
    func map(from modelToMap: ListingDTO) -> [Post] {
        let posts = modelToMap.data.children.compactMap({ child in
            let data = child.data
            let date = Date(timeIntervalSince1970: TimeInterval(floatLiteral: data.created))
            
            let multipleMedia = self.multipleMedia(data: data)
            
            var images: [PostImage]?
            let singleImages: [PostImage]? = self.singleImages(data: data)
            if let singleImages {
                images = singleImages
            } else if !multipleMedia.images.isEmpty {
                images = multipleMedia.images
            } else {
                images = nil
            }
            
            var videos: [PostVideo]?
            let video = self.singleVideo(data: data)
            if let video {
                videos = [video]
            } else if !multipleMedia.videos.isEmpty {
                videos = multipleMedia.videos
            } else {
                videos = nil
            }
            
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
                videos: videos,
                subredditId: data.subredditId,
                id: data.name,
                authorName: data.author,
                commentsCount: data.numComments,
                votedUp: data.likes
            )
        })
        return posts
    }
    
    private func multipleMedia(data: PostDTO) -> MultipleMedia {
        var media = MultipleMedia()
        guard let values = data.mediaMetadata?.values else {
            return media
        }
        for value in values {
            switch value.e {
            case "Image":
                guard let image = self.metadataImage(value: value) else { break }
                media.images.append(image)
            case "RedditVideo":
                guard let video = self.metadataVideo(value: value) else { break }
                media.videos.append(video)
            default:
                break
            }
        }
        return media
    }
    
    private func metadataImage(value: MediaMetadataDTO) -> PostImage? {
        guard let previews = value.p,
              let id = value.id
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
        
        if let fullImage = value.s,
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
    }
    
    private func metadataVideo(value: MediaMetadataDTO) -> PostVideo? {
        guard let id = value.id,
              let hlsUrl = value.hlsUrl,
              let height = value.y,
              let width = value.x
        else { return nil }
        return PostVideo(
            id: id,
            hlsUrl: hlsUrl,
            height: height,
            width: width
        )
    }
    
    private func singleVideo(data: PostDTO) -> PostVideo? {
        guard let video = data.media?.redditVideo
        else { return nil }
        
        var id: String?
        if let videoId = video.id {
            id = videoId
        }
        else {
            id = URL(string: video.hlsUrl)?
                .pathComponents
                .dropFirst()
                .first
        }
        return PostVideo(
            id: video.id ?? id ?? UUID().uuidString,
            hlsUrl: video.hlsUrl,
            height: video.height,
            width: video.width
        )
    }
    
    private func singleImages(data: PostDTO) -> [PostImage]? {
        guard !data.isVideo else { return nil } // If post contains only one video, its preview will be in preview images just as in a post that contains only single image
        let images: [PostImage]? = data.preview?.images?.compactMap({ image in
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
        })
        
        guard let images = images, !images.isEmpty else {
            return nil
        }
        return images
    }
}
