//
//  PostDetailsImageView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import SwiftUI
import Kingfisher

struct PostDetailsImageView: View {
    var id = UUID()
    var output: PostDetailsImagePresenterProtocol?
//    @ObservedObject private(set) var store: PostDetailsImageStore
//    var output: PostDetailsImagePresenterProtocol? = PostDeta
    @StateObject var store: PostDetailsImageStore = PostDetailsImageStore()
    
//    init(store: PostDetailsImageStore) {
//        self.store = store
//        withUnsafeMutablePointer(to: &self) { address in
//            print("\(Self.self) \(address) inited")
//        }
//    }
    init(store: PostDetailsImageStore) {
//        withUnsafeMutablePointer(to: &self) { address in
//            print("\(Self.self) \(address) inited")
//        }
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
                self.output?.startLoading()
            }
        }
    }
}
