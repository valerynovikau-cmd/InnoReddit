//
//  PostDetailsView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.12.25.
//

import SwiftUI
import Kingfisher
import Factory
import AVFoundation
import AVKit

fileprivate struct PostDetailsValues {
    static let moreSymbolName = "ellipsis"
    static let upvoteSymbolName = "arrow.up"
    static let downvoteSymbolName = "arrow.down"
    static let bookmarkSymbolName = "bookmark"
    
    static let mainVStackSpacing: CGFloat = 10
    static let headerLabelsVStackSpacing: CGFloat = 3
    static let headerLabelsLineLimit: Int = 1
    
    static let imageTabViewCornerRadius: CGFloat = 15
    static let imageTabViewAspectRatio: CGFloat = 1
}

fileprivate typealias constants = PostDetailsValues

struct PostDetailsView: View {
    @ObservedObject private(set) var store: PostDetailsStore
    
    init(store: PostDetailsStore) {
        self.store = store
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: constants.mainVStackSpacing) {
                
                PostDetailsHeaderView(output: self.store.output, store: self.store)
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                PostDetailsContentView(store: self.store)
                
                Divider()
                
                PostDetailsFooterView(output: self.store.output, store: self.store)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Asset.Assets.Colors.innoBackgroundColor.swiftUIColor)
        .onAppear {
            self.store.output?.retrieveSubbreditImage()
        }
    }
}

// MARK: - Header view
struct PostDetailsHeaderView: View {
    var output: PostDetailsPresenterProtocol?
    @ObservedObject var store: PostDetailsStore
    
    @ScaledMetric private var imageSize: CGFloat = 35
    @ScaledMetric private var buttonSize: CGFloat = 35
    @ScaledMetric private var circleSize: CGFloat = 4
    
    var body: some View {
        HStack {
            ZStack {
                Asset.Assets.Colors.innoSecondaryBackgroundColor.swiftUIColor
                
                if let icon = self.store.iconToShow {
                    switch icon {
                    case .defaultIcon:
                        Image(asset: Asset.Assets.Images.defaultSubredditAvatar)
                            .resizable()
                            
                    case .iconFromURL(let url):
                        KFImage(url)
                            .resizable()
                    }
                }
            }
            .clipShape(.circle)
            .frame(width: imageSize, height: imageSize)
            
            VStack(alignment: .leading, spacing: constants.headerLabelsVStackSpacing) {
                Text("r/\(self.store.subredditName ?? PostDetailsStrings.deletedSubreddit)")
                    .lineLimit(constants.headerLabelsLineLimit)
                
                HStack {
                    Text("u/\(self.store.authorName ?? PostDetailsStrings.deletedAuthor)")
                        .lineLimit(constants.headerLabelsLineLimit)
                    
                    Circle()
                        .frame(width: circleSize, height: circleSize)
                        .foregroundStyle(Color.primary)
                    
                    Text(self.store.date)
                        .lineLimit(constants.headerLabelsLineLimit)
                }
            }
            .font(.callout)
            
            Spacer()
            
            Button {
                self.output?.onMoreTap()
            } label: {
                Image(systemName: constants.moreSymbolName)
            }
            .frame(width: buttonSize, height: buttonSize)
            .tint(Color.primary)
        }
    }
}

// MARK: - Post content view
struct PostDetailsContentView: View {
    @ObservedObject private(set) var store: PostDetailsStore
    private let player = AVPlayer(url: URL(string: "https://v.redd.it/qqb2a5hr9c7g1/CMAF_1080.mp4?source=fallback")!)
    
    var body: some View {
        if let title = self.store.title {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
        }
        
        if self.store.content.count == 1,
           let content = self.store.content.first,
           case .text(let text) = content
        {
            if !text.isEmpty {
                Text(text)
                    .font(.body)
            }
            
            if let images = self.store.images {
                TabView {
                    ForEach(images) { image in
                        imageView(for: image)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: constants.imageTabViewCornerRadius))
                .frame(maxWidth: .infinity)
                .aspectRatio(constants.imageTabViewAspectRatio, contentMode: .fit)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            
            if let videos = self.store.videos {
                ForEach(videos) { video in
                    videoView(for: video)
                }
            }
        } else if self.store.content.count > 0 {
            ForEach(self.store.content, id: \.self) { item in
                view(for: item)
            }
        }
    }
    
    @ViewBuilder
    private func view(for item: PostTextContentType) -> some View {
        switch item {
        case .text(let text):
            Text(text)
                .font(.body)
        case .image(let image):
            imageView(for: image)
                .clipShape(RoundedRectangle(cornerRadius: constants.imageTabViewCornerRadius))
        }
    }
    
    private func imageView(for image: PostImage) -> some View {
        let url = URL(string: image.fullSource?.url ?? image.previewSource?.url ?? "")
        let store = Container.shared.postDetailsImageStore.resolve(url)
        return PostDetailsImageView(store: store)
            .frame(maxWidth: .infinity)
            .aspectRatio(constants.imageTabViewAspectRatio, contentMode: .fit)
    }
    
    private func videoView(for video: PostVideo) -> some View {
        let url = URL(string: video.hlsUrl)
        return PostDetailsVideoView(url: url)
            .aspectRatio(CGFloat(video.width) / CGFloat(video.height), contentMode: .fit)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Post footer view
struct PostDetailsFooterView: View {
    var output: PostDetailsPresenterProtocol?
    @ObservedObject var store: PostDetailsStore
    
    var body: some View {
        HStack {
            Button {
                self.output?.onUpvoteTap()
            } label: {
                Image(systemName: constants.upvoteSymbolName)
            }
            
            Text(store.score)
            
            Button {
                self.output?.onDownvoteTap()
            } label: {
                Image(systemName: constants.downvoteSymbolName)
            }
            
            Spacer()
            
            Button {
                self.output?.onBookmarkTap()
            } label: {
                Image(systemName: constants.bookmarkSymbolName)
            }
        }
        .font(.title)
        .tint(Color.primary)
    }
}
