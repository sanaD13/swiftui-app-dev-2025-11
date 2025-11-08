//
//  VideoPlayerControlsView.swift
//  VideoPlayer
//
//  Created by Sana Desai on 2025-11-07.
//

import SwiftUI
import AVKit

struct VideoPlayerControlsView: View {
    @ObservedObject var videoPlayerVM: VideoPlayerViewModel
    
    var body: some View {
        HStack(spacing: 24) {
            Button(action: { videoPlayerVM.goPrevious() }) {
                Image("previous")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            .disabled(!videoPlayerVM.canGoPrevious)
            .opacity(videoPlayerVM.canGoPrevious ? 1.0 : 0.4)
            .tint(.black)
            
            Button(action: { videoPlayerVM.playToggle() }) {
                Group {
                    if videoPlayerVM.isPlaying {
                        Image("pause")
                            .resizable()
                    } else {
                        Image("play")
                            .resizable()
                    }
                }
                .frame(width: 48, height: 48)
            }
            .tint(.black)
            
            Button(action: { videoPlayerVM.goNext() }) {
                Image("next")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            .disabled(!videoPlayerVM.canGoNext)
            .opacity(videoPlayerVM.canGoNext ? 1.0 : 0.4)
            .tint(.black)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

#Preview {
    @Previewable @StateObject var vm = VideoPlayerViewModel(api: APIClient())
    VideoPlayerControlsView(videoPlayerVM: vm)
}

