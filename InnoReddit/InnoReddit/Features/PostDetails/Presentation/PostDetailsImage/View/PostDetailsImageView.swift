//
//  PostDetailsImageView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import SwiftUI
import Kingfisher

fileprivate struct PostDetailsImageViewValues {
    static let blurRadius: CGFloat = 20
    static let shadowRadius: CGFloat = 5
    static let shadowAlpha: CGFloat = 0.2
    static let loadFailedVStackSpacing: CGFloat = 6
    static let loadFailedImageSystemName = "xmark.circle.fill"
}

private typealias constants = PostDetailsImageViewValues

struct PostDetailsImageView: View {
    @StateObject var store: PostDetailsImageStore
    
    init(store: PostDetailsImageStore) {
        self._store = StateObject(wrappedValue: store)
    }
    
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
                        .blur(radius: constants.blurRadius)
                        .frame(width: geometryProxy.size.height, height: geometryProxy.size.width)
                        .clipped()
                    
                    KFImage(url)
                        .fade(duration: self.store.fadeDuration)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color(uiColor: .black.withAlphaComponent(constants.shadowAlpha)), radius: constants.shadowRadius)
                case .loadFailed:
                    VStack(spacing: constants.loadFailedVStackSpacing) {
                        Image(systemName: constants.loadFailedImageSystemName)
                            .font(.largeTitle)
                            .foregroundStyle(Color.red)
                        Text(PostDetailsStrings.imageLoadFailed)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Asset.Assets.Colors.innoSecondaryBackgroundColor.swiftUIColor)
                case .none:
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
