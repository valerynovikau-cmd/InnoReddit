//
//  PostCellImageViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 21.11.25.
//

import UIKit

protocol PostCellImageViewProtocol: AnyObject {
    var output: PostCellImagePresenterProtocol? { get set }
    func onImageRetrieved(image: UIImage?, blurredImage: UIImage?)
}

final class PostCellImageViewController: UIViewController {
    var output: PostCellImagePresenterProtocol?
    private let animationInterval: TimeInterval = 0.1
    
    private let imageView = IRPostImageViewBlurredBackground()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output?.retrieveImage()
    }
}

extension PostCellImageViewController: PostCellImageViewProtocol {
    func onImageRetrieved(image: UIImage?, blurredImage: UIImage?) {
        imageView.setBackgorundImage(image: blurredImage, animationInterval: animationInterval)
        imageView.setImage(image: image, animationInterval: animationInterval)
    }
}
