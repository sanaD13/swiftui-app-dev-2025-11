//
//  VideoPlayerTests.swift
//  VideoPlayerTests
//
//  Created by Michael Gauthier on 2025-10-31.
//

import XCTest
@testable import VideoPlayer

final class VideoPlayerViewModelTests: XCTestCase {
    var viewModel: VideoPlayerViewModel!
    var mockVideos: [Video]!

    override func setUp() {
        super.setUp()
        mockVideos = [
            Video(
                id: "1",
                title: "Test Video 1",
                description: "Lorem Ipsum",
                hlsURL: URL(string: "https://example.com/1.mp4")!,
                fullURL: URL(string: "https://example.com/1.mp4")!,
                publishedAt: Date.now,
                author: Author(id: "11", name: "Jane Doe")
            ),
            Video(
                id: "2",
                title: "Test Video 2",
                description: "Lorem Ipsum",
                hlsURL: URL(string: "https://example.com/2.mp4")!,
                fullURL: URL(string: "https://example.com/2.mp4")!,
                publishedAt: Date.now.addingTimeInterval(36000),
                author: Author(id: "22", name: "John Doe")
            )
        ]
        viewModel = VideoPlayerViewModel(videos: mockVideos)
    }

    func testInitialVideoIsFirstInList() {
        XCTAssertEqual(viewModel.currentVideo?.title, "Test Video 1")
    }

    func testNextVideoUpdatesCurrentVideo() {
        viewModel.goNext()
        XCTAssertEqual(viewModel.currentVideo?.title, "Test Video 2")
    }

    func testPreviousVideoUpdatesCurrentVideo() {
        viewModel.goNext()
        viewModel.goPrevious()
        XCTAssertEqual(viewModel.currentVideo?.title, "Test Video 1")
    }

    func testNextVideoAtEndDoesNotCrash() {
        viewModel.goNext()
        viewModel.goNext()
        XCTAssertEqual(viewModel.currentVideo?.title, "Test Video 2") // stays last
    }

    func testPlayPauseTogglesPlaybackState() {
        viewModel.isPlaying = false
        viewModel.playToggle()
        XCTAssertTrue(viewModel.isPlaying)
    }
}

