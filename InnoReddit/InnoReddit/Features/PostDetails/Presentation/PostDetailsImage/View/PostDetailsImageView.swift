//
//  PostDetailsImageView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import SwiftUI
import Kingfisher

struct PostDetailsImageView: View {
    
    var output: PostDetailsImagePresenterProtocol?
    @ObservedObject private(set) var store: PostDetailsImageStore
    
    init(store: PostDetailsImageStore) {
        self.store = store
    }
    
    private let blurRadius: CGFloat = 20
    private let shadowRadius: CGFloat = 5
    private let shadowAlpha: CGFloat = 0.2
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack(alignment: .center) {
                switch self.store.viewState {
                case .startedLoading:
                    ProgressView()
                case .loaded(let url):
                    KFImage(url)
                        .fade(duration: self.store.fadeDuration)
                        .resizable()
                        .scaledToFill()
                        .blur(radius: blurRadius)
                        .frame(width: geometryProxy.size.height, height: geometryProxy.size.width)
                        .clipped()
                    
                    KFImage(url)
                        .fade(duration: self.store.fadeDuration)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color(uiColor: .black.withAlphaComponent(shadowAlpha)), radius: shadowRadius)
                case .loadFailed:
                    Text(":(")
                case .none:
                    EmptyView()
                }
            }
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            .onAppear {
                self.output?.startLoading()
            }
        }
    }
}
