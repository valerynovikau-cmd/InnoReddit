//
//  PostDetailsImageView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import SwiftUI
import Kingfisher

struct PostDetailsImageView: View {
    private var id = UUID()
    var imageURL: URL?
    @StateObject var store: PostDetailsImageStore
    
    init(imageURL: URL?) {
        let store = PostDetailsImageStore()
        let output = PostDetailsImagePresenter(imageURL: imageURL)
        store.output = output
        output.input = store
        self._store = StateObject(wrappedValue: store)
    }
    
    private let blurRadius: CGFloat = 20
    private let shadowRadius: CGFloat = 5
    private let shadowAlpha: CGFloat = 0.2
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack(alignment: .center) {
                switch self.store.viewState {
                case .startedLoading:
                    let _ = print("=============================== SHOWING PROGRESS VIEW \(id) ===============================")
                    ProgressView()
                case .loaded(let url):
                    let _ = print("=============================== SHOWING IMAGES \(id) ===============================")
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
                    let _ = print("=============================== SHOWING LOAD FAILED \(id) ===============================")
                    Text(":(")
                case .none:
                    let _ = print("=============================== SHOWING NOTHING \(id) ===============================")
                    EmptyView()
                }
            }
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            .onAppear {
                self.store.output?.startLoading()
            }
        }
    }
}
