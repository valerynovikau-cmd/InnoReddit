//
//  PostsPresenterProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

protocol PostsPresenterProtocol: AnyObject {
    var input: PostsViewProtocol? { get set }
    var isRetrievingPosts: Bool { get }
    
    var posts: [Post] { get }
    var postsAfter: String? { get }
    
    func preformPostsRetrieval()
    func performPostsPaginatedRetrieval()
}
