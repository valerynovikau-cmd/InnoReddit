//
//  MainFeedPresenterProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

protocol MainFeedPresenterProtocol: AnyObject {
    var input: MainFeedViewProtocol? { get set }
    var bestPosts: [Post] { get }
    var hotPosts: [Post] { get }
    var newPosts: [Post] { get }
    var topPosts: [Post] { get }
    var risingPosts: [Post] { get }
    func preformHotPostsRetrieval()
}
