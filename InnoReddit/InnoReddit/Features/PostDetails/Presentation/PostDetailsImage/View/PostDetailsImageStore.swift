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
}

final class PostDetailsImageStore: ObservableObject {
    @Published var viewState: PostImageState = .none
    
    let fadeDuration: TimeInterval = 0.1
}

extension PostDetailsImageStore: PostDetailsImageStoreProtocol {
    func animatedStateChange(state: PostImageState) {
        withAnimation(.easeIn(duration: fadeDuration)) {
            self.viewState = state
        }
    }
}
