//
//  PostDetailsImagePresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import Foundation
import Kingfisher

protocol PostDetailsImagePresenterProtocol: AnyObject {
    var input: PostDetailsImageStoreProtocol? { get set }
    var imageURL: URL? { get }
    func startLoading()
}

final class PostDetailsImagePresenter {
    var input: PostDetailsImageStoreProtocol?
    private(set) var imageURL: URL?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
}

extension PostDetailsImagePresenter: PostDetailsImagePresenterProtocol {
    func startLoading() {
        self.input?.animatedStateChange(state: .startedLoading)
        guard let url = self.imageURL else {
            self.input?.animatedStateChange(state: .loadFailed)
            return
        }
        Task { [weak self] in
            guard let self else {
                return
            }
            var newState: PostImageState
            let result = try? await KingfisherManager.shared.retrieveImage(with: url)
            if result != nil {
                newState = .loaded(imageURL)
            } else {
                newState = .loadFailed
            }
            
            await MainActor.run {
                self.input?.animatedStateChange(state: newState)
            }
        }
    }
}
