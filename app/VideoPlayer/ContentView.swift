//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Michael Gauthier on 2025-10-31.
//

import SwiftUI
import AVKit
import MarkdownUI

struct ContentView: View {
    @StateObject private var videoPlayerVM = VideoPlayerViewModel(api: APIClient())

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Video player region
                ZStack {
                    if let player = videoPlayerVM.player {
                        VideoPlayer(player: player)
                            .aspectRatio(16/9, contentMode: .fit)
                            .background(Color.black)
                            .onDisappear {
                                player.pause()
                            }
                    } else {
                        Rectangle()
                            .foregroundColor(.black)
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay(Text("No video loaded").foregroundColor(.white))
                    }

                        VideoPlayerControlsView(videoPlayerVM: videoPlayerVM)
                            .padding(.horizontal)
                }

                // Details View - scrollable
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if let videoDetails = videoPlayerVM.currentVideo {
                            Text(videoDetails.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("By \(videoDetails.author)")
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.secondary)

                            Divider()

                            // Markdown rendering
                            Markdown(videoDetails.description)
                                .font(.body)
                        } else if let error = videoPlayerVM.errorMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                        } else {
                            Text("Loading...")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemBackground))
            }
            .navigationBarTitle("Videos", displayMode: .inline)
        }
        .onAppear {
            videoPlayerVM.fetchAndLoad()
        }
    }
}

#Preview {
    ContentView()
}
