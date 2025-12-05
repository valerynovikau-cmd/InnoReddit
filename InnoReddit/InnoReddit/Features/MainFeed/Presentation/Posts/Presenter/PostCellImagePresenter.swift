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
        Task { [weak self] in
            do {
                guard let self,
                      let urlString = postImage.previewUrl ?? postImage.fullUrl,
                      let url = URL(string: urlString)
                else { return }
                let blurImageProcessor = BlurImageProcessor(blurRadius: blurRadius)
                let imageBlurredResult = try await KingfisherManager.shared.retrieveImage(
                    with: url,
                    options: [
                        .processor(blurImageProcessor)
                    ]
                )
                
                let imageResult = try await KingfisherManager.shared.retrieveImage(
                    with: url
                )
                didRetrieveImage = true
                input?.onImageRetrieved(image: imageResult.image, blurredImage: imageBlurredResult.image)
            } catch { }
        }
    }
}
