//
//  PostTextDataSeparatorTest.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 10.12.25.
//

import XCTest
@testable import InnoReddit

final class PostTextDataSeparatorTest: XCTestCase {
    
    let firstText = "text_text1 "
    let firstImage = PostImage(
        id: "id",
        fullSource: PostImageSource(
            url: "https://reddit.com/image3",
            width: 0,
            height: 0
        ),
        previewSource: PostImageSource(
            url: "https://reddit.com/image3",
            width: 0,
            height: 0
        )
    )
    let secondText = " text_text2 "
    let secondImage = PostImage(
        id: "id",
        fullSource: PostImageSource(
            url: "https://reddit.com/image1",
            width: 0,
            height: 0
        ),
        previewSource: PostImageSource(
            url: "https://reddit.com/image1",
            width: 0,
            height: 0
        )
    )
    let thirdText = " text_text3 "
    let thirdImage = PostImage(
        id: "id",
        fullSource: PostImageSource(
            url: "https://reddit.com/image2",
            width: 0,
            height: 0
        ),
        previewSource: PostImageSource(
            url: "https://reddit.com/image2",
            width: 0,
            height: 0
        )
    )
    let fourthText = " text_text4"
    
    @MainActor func test_optimistic() {
        let postImages: [PostImage] = [firstImage, secondImage, thirdImage]
        let postText = "\(firstText)\(firstImage.fullSource!.url)\(secondText)\(secondImage.fullSource!.url)\(thirdText)\(thirdImage.fullSource!.url)\(fourthText)"
        let post = Post(
            subreddit: nil,
            text: postText,
            authorId: nil,
            saved: false,
            title: nil,
            downs: 0,
            ups: 0,
            score: 0,
            created: Date(),
            images: postImages,
            videos: nil,
            subredditId: "",
            id: "id",
            authorName: nil,
            commentsCount: 0
        )
        let result = PostTextDataSeparator.separatePostContents(post: post)
        let awaitedResult: [PostTextContentType] = [
            .text(firstText),
            .image(firstImage),
            .text(secondText),
            .image(secondImage),
            .text(thirdText),
            .image(thirdImage),
            .text(fourthText)
        ]
        XCTAssert(result == awaitedResult)
    }
    
    @MainActor func test_noImagesInText() {
        let postImages: [PostImage] = [firstImage, secondImage, thirdImage]
        let postText = "text text text"
        let post = Post(
            subreddit: nil,
            text: postText,
            authorId: nil,
            saved: false,
            title: nil,
            downs: 0,
            ups: 0,
            score: 0,
            created: Date(),
            images: postImages,
            videos: nil,
            subredditId: "",
            id: "id",
            authorName: nil,
            commentsCount: 0
        )
        let result = PostTextDataSeparator.separatePostContents(post: post)
        let awaitedResult: [PostTextContentType] = [
            .text(postText)
        ]
        XCTAssert(result == awaitedResult)
    }
    
    @MainActor func test_onlyImageInText() {
        let postImages: [PostImage] = [firstImage]
        let postText = "\(firstImage.fullSource!.url)"
        let post = Post(
            subreddit: nil,
            text: postText,
            authorId: nil,
            saved: false,
            title: nil,
            downs: 0,
            ups: 0,
            score: 0,
            created: Date(),
            images: postImages,
            videos: nil,
            subredditId: "",
            id: "id",
            authorName: nil,
            commentsCount: 0
        )
        let result = PostTextDataSeparator.separatePostContents(post: post)
        let awaitedResult: [PostTextContentType] = [
            .image(firstImage)
        ]
        XCTAssert(result == awaitedResult)
    }
    
    @MainActor func test_imageAtTheEnd() {
        let postImages: [PostImage] = [firstImage]
        let postText = "\(firstText)\(firstImage.fullSource!.url)"
        let post = Post(
            subreddit: nil,
            text: postText,
            authorId: nil,
            saved: false,
            title: nil,
            downs: 0,
            ups: 0,
            score: 0,
            created: Date(),
            images: postImages,
            videos: nil,
            subredditId: "",
            id: "id",
            authorName: nil,
            commentsCount: 0
        )
        let result = PostTextDataSeparator.separatePostContents(post: post)
        let awaitedResult: [PostTextContentType] = [
            .text(firstText),
            .image(firstImage)
        ]
        XCTAssert(result == awaitedResult)
    }
}
