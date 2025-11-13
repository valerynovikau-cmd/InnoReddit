//
//  PostsViewProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

protocol PostsViewProtocol: AnyObject {
    var output: PostsPresenterProtocol? { get set }
    func onPostsUpdated()
}
