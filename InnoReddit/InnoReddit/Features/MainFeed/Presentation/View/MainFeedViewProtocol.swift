//
//  MainFeedViewProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

protocol MainFeedViewProtocol: AnyObject {
    var output: MainFeedPresenterProtocol? { get set }
    func onHotPostsUpdated()
    func onBestPostsUpdated()
    func onNewPostsUpdated()
    func onTopPostsUpdated()
    func onRisingPostsUpdated()
}
