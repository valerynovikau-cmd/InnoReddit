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
    func retrieveImage(blurRadius: CGFloat)
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
    func retrieveImage(blurRadius: CGFloat) {
        guard !didRetrieveImage else { return }
        Task {
            do {
                guard let url = postImage.previewUrl ?? postImage.fullUrl else { return }
                let blurImageProcessor = BlurImageProcessor(blurRadius: blurRadius)
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
            } catch { }
        }
    }
}
