//
//  PostDetailsVideoView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 16.12.25.
//

import SwiftUI
import AVKit

struct PostDetailsVideoView: View {
    @State private var player: AVPlayer?
    
    init(url: URL?) {
        let player = AVPlayer(url: url ?? URL(string: "")!)
        _player = State(wrappedValue: player)
    }
    
    var body: some View {
        VideoPlayer(player: player)
    }
}
