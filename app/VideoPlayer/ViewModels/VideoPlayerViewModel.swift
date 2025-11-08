//
//  VideoPlayerViewModel.swift
//  VideoPlayer
//
//  Created by Sana Desai on 2025-11-07.
//

import Foundation
import AVKit
import Combine

final class VideoPlayerViewModel: ObservableObject {
    @Published private(set) var videos: [Video] = []
    @Published private(set) var currentIndex: Int = 0
    @Published var player: AVPlayer? = nil
    @Published var isPlaying: Bool = false
    @Published var errorMessage: String? = nil
    
    private let fetchVideosAPI: APIClient
    private var cancellables = Set<AnyCancellable>()
    
    var currentVideo: Video? {
        guard videos.indices.contains(currentIndex) else { return nil }
        return videos[currentIndex]
    }
    
    var canGoNext: Bool {
        return currentIndex < videos.count - 1
    }
    
    var canGoPrevious: Bool {
        return currentIndex > 0
    }
    
    init(api: APIClient = APIClient()) {
        self.player = AVPlayer()
        self.fetchVideosAPI = api
    }
    
    // TODO: adding another initializer for testing. Should find a better solution
    init(videos: [Video] = []) {
        self.videos = videos
        self.player = AVPlayer()
        self.fetchVideosAPI = APIClient()
    }
    
    func fetchAndLoad() {
        fetchVideosAPI.fetchVideos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetched):
                    // sort by date descending so that recent videos are first. Change to ascending if that what client needs.
                    let sorted = fetched.sorted { $0.publishedAt > $1.publishedAt }
                    self?.videos = sorted
                    if !sorted.isEmpty {
                        // pre-load the first video
                        self?.loadVideo(at: 0, play: false)
                    }
                case .failure(let err):
                    self?.errorMessage = String(describing: err)
                }
            }
        }
    }
    
    func loadVideo(at index: Int, play: Bool) {
        guard videos.indices.contains(index), let player = self.player else { return }
        currentIndex = index
        
        let newItem = AVPlayerItem(url: videos[index].playbackURL)
        player.replaceCurrentItem(with: newItem)
        // ensure video is paused initially
        player.pause()
        isPlaying = false
        
        // if coming from "next" or "previous" buttons, play the video
        if play {
            player.play()
            isPlaying = true
        }
    }
    
    func playToggle() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func goNext() {
        guard canGoNext else { return }
        let nextIndex = currentIndex + 1
        loadVideo(at: nextIndex, play: true)
    }
    
    func goPrevious() {
        guard canGoPrevious else { return }
        let prev = currentIndex - 1
        loadVideo(at: prev, play: true)
    }
}
