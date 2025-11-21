//
//  PostCellImagePresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 21.11.25.
//

import Kingfisher
import Foundation

protocol PostCellImagePresenterProtocol: AnyObject {
    var input: PostCellImageViewProtocol? { get set }
    func retrieveImage()
}

final class PostCellImagePresenter {
    weak var input: PostCellImageViewProtocol?
    
    private let postImage: PostImage
    private var didRetrieveImage = false
    
    init(postImage: PostImage) {
        self.postImage = postImage
    }
}

extension PostCellImagePresenter: PostCellImagePresenterProtocol {
    func retrieveImage() {
        guard !didRetrieveImage else { return }
        Task {
            guard let url = postImage.previewUrl ?? postImage.fullUrl else { return }
            let blurImageProcessor = BlurImageProcessor(blurRadius: 20)
            let imageBlurredResult = try await KingfisherManager.shared.retrieveImage(
                with: URL(string: url)!,
                options: [
                    .processor(blurImageProcessor)
                ]
            )
            
            let imageResult = try await KingfisherManager.shared.retrieveImage(
                with: URL(string: url)!
            )
            didRetrieveImage = true
            input?.onImageRetrieved(image: imageResult.image, blurredImage: imageBlurredResult.image)
        }
    }
}

//for image in images {
//    let imageView = IRPostImageViewBlurredBackground()
//    imageView.layer.cornerRadius = constants.previewImageCornerRadius
//    imageView.clipsToBounds = true
//    NSLayoutConstraint.activate([
//        imageView.widthAnchor.constraint(equalToConstant: postContentStackView.frame.width),
//        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
//    ])
//
//    postImagesStackView.addArrangedSubview(imageView)
//
//    Task {
//        let blurImageProcessor = BlurImageProcessor(blurRadius: 20)
//        let imageBlurredResult = try await KingfisherManager.shared.retrieveImage(
//            with: URL(string: image.fullUrl ?? "")!,
//            options: [
//                .processor(blurImageProcessor)
//            ]
//        )
//        await MainActor.run {
//            imageView.setBackgorundImage(image: imageBlurredResult.image, animationInterval: constants.fadeInAnimationDuration)
//        }
//
//        let imageResult = try await KingfisherManager.shared.retrieveImage(
//            with: URL(string: image.fullUrl ?? "")!
//        )
//        await MainActor.run {
//            imageView.setImage(image: imageResult.image, animationInterval: constants.fadeInAnimationDuration)
//        }
//    }
//}
