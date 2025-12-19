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
    static let upvoteSymbolName = "arrowshape.up"
    static let upvoteSymbolNameVoted = "arrowshape.up.fill"
    static let downvoteSymbolName = "arrowshape.down"
    static let downvoteSymbolNameVoted = "arrowshape.down.fill"
    
    static let bookmarkSymbolName = "bookmark"
    static let bookmarkSymbolNameSaved = "bookmark.fill"
    
    static let mainVStackSpacing: CGFloat = 10
    static let headerLabelsVStackSpacing: CGFloat = 3
    static let headerLabelsLineLimit: Int = 1
    
    static let mediaCornerRadius: CGFloat = 15
    static let imageTabViewAspectRatio: CGFloat = 1
    
    static let scoreTextMinimalWidth: CGFloat = 25
    static let scoreTextLineLimit: Int = 1
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
            
            Group {
                if let images = self.store.images {
                    TabView {
                        ForEach(images) { image in
                            imageView(for: image)
                        }
                    }
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
            }
            .clipShape(RoundedRectangle(cornerRadius: constants.mediaCornerRadius))
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
                .clipShape(RoundedRectangle(cornerRadius: constants.mediaCornerRadius))
        case .video(let video):
            videoView(for: video)
                .clipShape(RoundedRectangle(cornerRadius: constants.mediaCornerRadius))
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
            PostDetailsLoaderView(isShowingLoader: self.store.isModifyingScore) {
                HStack {
                    Button {
                        self.output?.onUpvoteTap(state: self.store.scoreState)
                    } label: {
                        if self.store.scoreState == .upVoted {
                            Image(systemName: constants.upvoteSymbolNameVoted)
                                .tint(Asset.Assets.Colors.innoOrangeColor.swiftUIColor)
                        } else {
                            Image(systemName: constants.upvoteSymbolName)
                        }
                    }
                    
                    Text(store.score)
                        .frame(minWidth: constants.scoreTextMinimalWidth)
                        .lineLimit(constants.scoreTextLineLimit)
                        .foregroundStyle(self.store.isModifyingScore ? .tertiary : .primary)
                    
                    Button {
                        self.output?.onDownvoteTap(state: self.store.scoreState)
                    } label: {
                        if self.store.scoreState == .downVoted {
                            Image(systemName: constants.downvoteSymbolNameVoted)
                                .tint(Asset.Assets.Colors.innoOrangeColor.swiftUIColor)
                        } else {
                            Image(systemName: constants.downvoteSymbolName)
                        }
                    }
                }
            }
            
            Spacer()
            
            PostDetailsLoaderView(isShowingLoader: self.store.isModifyingSave) {
                Button {
                    self.output?.onBookmarkTap(state: self.store.saveState)
                } label: {
                    if self.store.saveState == .none {
                        Image(systemName: constants.bookmarkSymbolName)
                    } else {
                        Image(systemName: constants.bookmarkSymbolNameSaved)
                            .tint(Asset.Assets.Colors.innoOrangeColor.swiftUIColor)
                    }
                }
            }
        }
        .font(.title)
        .tint(Color.primary)
    }
}

// MARK: - View with loader
struct PostDetailsLoaderView<Content: View>: View {
    let isShowingLoader: Bool
    let content: Content
    
    init(
        isShowingLoader: Bool,
        @ViewBuilder view: () -> Content
    ) {
        self.isShowingLoader = isShowingLoader
        self.content = view()
    }
    
    var body: some View {
        ZStack {
            content
                .disabled(isShowingLoader)
            
            if isShowingLoader {
                ProgressView()
            }
        }
    }
}
