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
    
    private var sampleText: String = """
Sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text 
"""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(asset: Asset.Images.defaultSubredditAvatar)
                        .resizable()
                        .clipShape(.circle)
                        .frame(width: imageSize, height: imageSize)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("r/test")
                            .lineLimit(1)
                        
                        HStack {
                            Text("u/user12498302985")
                                .lineLimit(1)
                            
                            Circle()
                                .frame(width: circleSize, height: circleSize)
                                .foregroundStyle(Color.primary)
                            
                            Text("4 days ago")
                                .lineLimit(1)
                        }
                    }
                    .font(.callout)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .frame(width: buttonSize, height: buttonSize)
                    .tint(Color.primary)
                }
                .frame(maxWidth: .infinity)
                
                Text(sampleText)
                
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
                
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.up")
                    }
                    
                    Text("120")
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.down")
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                    }
                }
                .font(.title)
                .tint(Color.primary)
                
                Spacer()
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
    PostDetailsView()
}
