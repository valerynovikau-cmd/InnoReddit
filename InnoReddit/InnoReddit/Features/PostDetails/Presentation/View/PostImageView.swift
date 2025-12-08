//
//  PostImageView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import SwiftUI

struct PostImageView: View {
    let asset: ImageAsset
    
    private let blurRadius: CGFloat = 20
    private let shadowRadius: CGFloat = 5
    private let shadowAlpha: CGFloat = 0.2
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                Image(asset: asset)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: blurRadius)
                    .frame(width: geometryProxy.size.height, height: geometryProxy.size.width)
                    .clipped()
                
                Image(asset: asset)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: Color(uiColor: .black.withAlphaComponent(shadowAlpha)), radius: shadowRadius)
            }
        }
    }
}
