//
//  PostDetailsView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 5.12.25.
//

import SwiftUI

struct PostDetailsView: View {
    @ScaledMetric private var imageSize: CGFloat = 35
    @ScaledMetric private var buttonSize: CGFloat = 35
    @ScaledMetric private var circleSize: CGFloat = 4
    
    var output: PostDetailsPresenterProtocol?
    @ObservedObject private(set) var store: PostDetailsStore
    
    init(store: PostDetailsStore) {
        self.store = store
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(asset: Asset.Images.defaultSubredditAvatar)
                        .resizable()
                        .background(Asset.Colors.innoSecondaryBackgroundColor.swiftUIColor)
                        .clipShape(.circle)
                        .frame(width: imageSize, height: imageSize)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("r/\(self.store.subredditName ?? "[deleted]")")
                            .lineLimit(1)
                        
                        HStack {
                            Text("u/\(self.store.authorName ?? "[deleted]")")
                                .lineLimit(1)
                            
                            Circle()
                                .frame(width: circleSize, height: circleSize)
                                .foregroundStyle(Color.primary)
                            
                            Text(self.store.date)
                                .lineLimit(1)
                        }
                    }
                    .font(.callout)
                    
                    Spacer()
                    
                    Button {
                        self.output?.onMoreTap()
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .frame(width: buttonSize, height: buttonSize)
                    .tint(Color.primary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                if let title = self.store.title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                if let text = self.store.text {
                    Text(text)
                        .font(.body)
                }
                
                TabView {
                    PostImageView(asset: Asset.Images.test1, color: .green)
                    PostImageView(asset: Asset.Images.test2, color: .blue)
                    PostImageView(asset: Asset.Images.test3, color: .green)
                    PostImageView(asset: Asset.Images.test4, color: .blue)
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Divider()
                
                HStack {
                    Button {
                        self.output?.onUpvoteTap()
                    } label: {
                        Image(systemName: "arrow.up")
                    }
                    
                    Text(store.score)
                    
                    Button {
                        self.output?.onDownvoteTap()
                    } label: {
                        Image(systemName: "arrow.down")
                    }
                    
                    Spacer()
                    
                    Button {
                        self.output?.onBookmarkTap()
                    } label: {
                        Image(systemName: "bookmark")
                    }
                }
                .font(.title)
                .tint(Color.primary)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Asset.Colors.innoBackgroundColor.swiftUIColor)
    }
}

struct PostImageView: View {
    
    let asset: ImageAsset
    let color: Color
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                Image(asset: asset)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 20)
                    .frame(width: geometryProxy.size.height, height: geometryProxy.size.width)
                    .clipped()
                
                Image(asset: asset)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: Color(uiColor: .black.withAlphaComponent(0.2)), radius: 5)
            }
        }
    }
}

#Preview {
    let post = Post(
        subreddit: "testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttest",
        text: "Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text Sample text ",
        authorId: "skebob",
        saved: false,
        title: "Sample title",
        downs: 0,
        ups: 0,
        score: 120000,
        created: Date().addingTimeInterval(-3600),
        images: [PostImage(id: "a", fullUrl: "", fullWidth: 1, fullHeight: 1, previewUrl: "", previewWidth: 1, previewHeight: 1)],
        subredditId: "skebob",
        id: "skebob",
        authorName: "authorName",
        commentsCount: 11241
    )
    let store = PostDetailsStore()
    let output = PostDetailsPresenter(post: post)
    output.input = store
    var view = PostDetailsView(store: store)
    view.output = output
    
    return view
}
