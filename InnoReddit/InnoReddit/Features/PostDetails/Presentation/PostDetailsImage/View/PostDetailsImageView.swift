//
//  PostDetailsImageView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import SwiftUI
import Kingfisher

struct PostDetailsImageView: View {
    let imageURL: URL?
    
    @State private var viewState: PostImageState = .none
    
    private let blurRadius: CGFloat = 20
    private let shadowRadius: CGFloat = 5
    private let shadowAlpha: CGFloat = 0.2
    private let fadeDuration: TimeInterval = 0.1
    
    private enum PostImageState {
        case startedLoading
        case loaded
        case loadFailed
        case none
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack(alignment: .center) {
                switch viewState {
                case .startedLoading:
                    ProgressView()
                case .loaded:
                    KFImage(imageURL)
                        .fade(duration: fadeDuration)
                        .resizable()
                        .scaledToFill()
                        .blur(radius: blurRadius)
                        .frame(width: geometryProxy.size.height, height: geometryProxy.size.width)
                        .clipped()
                    
                    KFImage(imageURL)
                        .fade(duration: fadeDuration)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color(uiColor: .black.withAlphaComponent(shadowAlpha)), radius: shadowRadius)
                case .loadFailed:
                    Text("сосать")
                case .none:
                    EmptyView()
                }
            }
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            .onAppear {
                startLoading()
            }
        }
    }
    
    private func startLoading() {
        animatedStateChange(state: .startedLoading)
        guard let url = imageURL else {
            animatedStateChange(state: .loadFailed)
            return
        }
        Task {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                var newState: PostImageState
                switch result {
                case .success:
                    newState = .loaded
                case .failure:
                    newState  = .loadFailed
                }
                DispatchQueue.main.async {
                    animatedStateChange(state: newState)
                }
            }
        }
    }
    
    private func animatedStateChange(state: PostImageState) {
        withAnimation(.easeIn(duration: fadeDuration)) {
            viewState = state
        }
    }
}
