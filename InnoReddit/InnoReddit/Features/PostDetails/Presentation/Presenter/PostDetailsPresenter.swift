//
//  PostDetailsPresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.12.25.
//

protocol PostDetailsPresenterProtocol: AnyObject {
    var input: PostDetailsStoreProtocol? { get set }
    
    var post: Post { get }
    
    func onBookmarkTap()
    func onUpvoteTap()
    func onDownvoteTap()
    func onMoreTap()
}

final class PostDetailsPresenter {
    weak var input: PostDetailsStoreProtocol? {
        didSet {
            input?.configure(post: self.post)
        }
    }
    private(set) var post: Post
    
    init(post: Post) {
        self.post = post
    }
}

extension PostDetailsPresenter: PostDetailsPresenterProtocol {
    func onBookmarkTap() {
        input?.onBookmarkTap()
    }
    
    func onUpvoteTap() {
        input?.onUpvoteTap()
    }
    
    func onDownvoteTap() {
        input?.onDownvoteTap()
    }
    
    func onMoreTap() {
        input?.onMoreTap()
    }
}
