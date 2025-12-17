//
//  PostDetailsImageStore.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import Combine
import Foundation
import SwiftUI

enum PostImageState {
    case startedLoading
    case loaded(URL?)
    case loadFailed
    case none
}

protocol PostDetailsImageStoreProtocol: AnyObject {
    func animatedStateChange(state: PostImageState)
    var output: PostDetailsImagePresenterProtocol? { get set }
}

final class PostDetailsImageStore: ObservableObject {
    @Published private(set) var viewState: PostImageState = .none
    var output: PostDetailsImagePresenterProtocol?
    
    let fadeDuration: TimeInterval = 0.1
}

extension PostDetailsImageStore: PostDetailsImageStoreProtocol {
    func animatedStateChange(state: PostImageState) {
        withAnimation(.easeIn(duration: fadeDuration)) {
            self.viewState = state
        }
    }
}
