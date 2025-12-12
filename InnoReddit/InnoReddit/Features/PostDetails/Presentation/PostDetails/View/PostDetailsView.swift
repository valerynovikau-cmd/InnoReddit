//
//  PostDetailsView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.12.25.
//

import SwiftUI
import Kingfisher
import Factory

struct PostDetailsView: View {
    
    var output: PostDetailsPresenterProtocol?
    @ObservedObject private(set) var store: PostDetailsStore
    
    init(store: PostDetailsStore) {
        self.store = store
    }
    
    private enum PostDetailsButtonSymbols: String {
        case more = "ellipsis"
        case upvote = "arrow.up"
        case downvote = "arrow.down"
        case bookmark = "bookmark"
    }
    
    private let mainVStackSpacing: CGFloat = 10
    private let headerLabelsVStackSpacing: CGFloat = 3
    private let headerLabelsLineLimit: Int = 1
    private let imageTabViewCornerRadius: CGFloat = 15
    private let imageTabViewAspectRatio: CGFloat = 1
    @ScaledMetric private var imageSize: CGFloat = 35
    @ScaledMetric private var buttonSize: CGFloat = 35
    @ScaledMetric private var circleSize: CGFloat = 4
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: mainVStackSpacing) {
                
                // MARK: - Header info(subreddit, author, post date)
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
                    
                    VStack(alignment: .leading, spacing: headerLabelsVStackSpacing) {
                        Text("r/\(self.store.subredditName ?? PostDetailsStrings.deletedSubreddit)")
                            .lineLimit(headerLabelsLineLimit)
                        
                        HStack {
                            Text("u/\(self.store.authorName ?? PostDetailsStrings.deletedAuthor)")
                                .lineLimit(headerLabelsLineLimit)
                            
                            Circle()
                                .frame(width: circleSize, height: circleSize)
                                .foregroundStyle(Color.primary)
                            
                            Text(self.store.date)
                                .lineLimit(headerLabelsLineLimit)
                        }
                    }
                    .font(.callout)
                    
                    Spacer()
                    
                    Button {
                        self.output?.onMoreTap()
                    } label: {
                        Image(systemName: PostDetailsButtonSymbols.more.rawValue)
                    }
                    .frame(width: buttonSize, height: buttonSize)
                    .tint(Color.primary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                // MARK: - Post contents
                
                if let title = self.store.title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                if self.store.content.count == 1,
                   let content = self.store.content.first,
                   case .text(let text) = content
                { // Post text doesn't contain images inside of it
                    if !text.isEmpty {
                        Text(text)
                            .font(.body)
                    }
                    
                    if let images = self.store.images {
                        TabView {
                            ForEach(images) { image in
                                let _ = print("Entered ForEach for \(image.id)")
                                let url = URL(string: image.fullSource?.url ?? image.previewSource?.url ?? "")
                                PostDetailsImageView(imageURL: url)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: imageTabViewCornerRadius))
                        .frame(maxWidth: .infinity)
                        .aspectRatio(imageTabViewAspectRatio, contentMode: .fit)
                        .tabViewStyle(.page)
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                    }
                } else if self.store.content.count > 0 { // Post text contains images inside of it
                    ForEach(self.store.content, id: \.self) { item in
                        view(for: item)
                    }
                }
                
                Divider()
                
                // MARK: - Bottom buttons
                
                HStack {
                    Button {
                        self.output?.onUpvoteTap()
                    } label: {
                        Image(systemName: PostDetailsButtonSymbols.upvote.rawValue)
                    }
                    
                    Text(store.score)
                    
                    Button {
                        self.output?.onDownvoteTap()
                    } label: {
                        Image(systemName: PostDetailsButtonSymbols.downvote.rawValue)
                    }
                    
                    Spacer()
                    
                    Button {
                        self.output?.onBookmarkTap()
                    } label: {
                        Image(systemName: PostDetailsButtonSymbols.bookmark.rawValue)
                    }
                }
                .font(.title)
                .tint(Color.primary)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Asset.Assets.Colors.innoBackgroundColor.swiftUIColor)
        .onAppear {
            self.output?.retrieveSubbreditImage()
        }
    }
    
    @ViewBuilder
    private func view(for item: PostTextContentType) -> some View {
        switch item {
        case .text(let text):
            let _ = print("Entered ForEach for text \(text.prefix(10))...")
            Text(text)
                .font(.body)
        case .image(let image):
            let _ = print("Entered ForEach for image \(image.id)")
            imageView(for: image)
        }
    }
    
    private func imageView(for image: PostImage) -> some View {
        let url = URL(string: image.fullSource?.url ?? image.previewSource?.url ?? "")

        return PostDetailsImageView(imageURL: url)
            .clipShape(RoundedRectangle(cornerRadius: imageTabViewCornerRadius))
            .frame(maxWidth: .infinity)
            .aspectRatio(imageTabViewAspectRatio, contentMode: .fit)
    }
}
