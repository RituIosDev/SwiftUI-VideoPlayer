//
//  VideoPlayerTests.swift
//  VideoPlayerTests
//
//  Created by Ritu on 2025-11-07.
//

import Testing
import Foundation
@testable import VideoPlayer

// MARK: - VideoPlayerViewModel Tests with Mock API
@MainActor
struct VideoPlayerViewModelTests {
    
    //Check for Mock API service initilization
    @Test func testInitializationWithMockService() async {
        let mockService = MockVideoApiService()
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        
        #expect(viewModel.videos.isEmpty)
        #expect(viewModel.currentVideoIndex == 0)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isPlaying == false)
    }
    
    //Test for Successfully Video Datat return
    @Test func testLoadVideosSuccess() async {
        let mockService = MockVideoApiService()
        let sampleVideos = MockVideoApiService.createSampleVideos()
        mockService.videosToReturn = sampleVideos
        
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        
        await viewModel.loadVideos()
        
        #expect(viewModel.videos.count == 3)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.currentVideoIndex == 0)
        #expect(mockService.fetchVideosCallCount == 1)
    }
    
    //Test for Empty Result
    @Test func testLoadVideosWithEmptyResult() async {
        let mockService = MockVideoApiService()
        mockService.videosToReturn = []
        
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        
        await viewModel.loadVideos()
        
        #expect(viewModel.videos.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == "No videos available")
        #expect(viewModel.currentVideoIndex == 0)
        #expect(viewModel.player == nil)
    }
    
    //Test for Network failure
    @Test func testLoadVideosWithNetworkError() async {
        let mockService = MockVideoApiService()
        mockService.shouldThrowError = URLError(.cannotConnectToHost)
        
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        
        await viewModel.loadVideos()
        
        #expect(viewModel.videos.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage?.contains("Network error") == true)
        #expect(viewModel.currentVideoIndex == 0)
        #expect(viewModel.player == nil)
    }
    
    //Test for Current Video property like id and title
    @Test func testCurrentVideoProperty() async {
        let mockService = MockVideoApiService()
        let sampleVideos = MockVideoApiService.createSampleVideos()
        mockService.videosToReturn = sampleVideos
        
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        await viewModel.loadVideos()
        
        let currentVideo = viewModel.currentVideo
        #expect(currentVideo != nil)
        #expect(currentVideo?.id == "1")
        #expect(currentVideo?.title == "First Video")
        
        viewModel.currentVideoIndex = 1
        let currentVideo2 = viewModel.currentVideo
        #expect(currentVideo2?.id == "2")
        #expect(currentVideo2?.title == "Second Video")
    }
    
    //Check for index out of bound for array
    @Test func testCurrentVideoReturnsNilWhenIndexOutOfBounds() async {
        let mockService = MockVideoApiService()
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        
        // Empty videos
        let currentVideo = viewModel.currentVideo
        #expect(currentVideo == nil)
        
        // Load videos
        let sampleVideos = MockVideoApiService.createSampleVideos()
        mockService.videosToReturn = sampleVideos
        await viewModel.loadVideos()
        
        // Set invalid index
        viewModel.currentVideoIndex = 10
        let currentVideo2 = viewModel.currentVideo
        #expect(currentVideo2 == nil)
    }
    
    //Check Previous action
    @Test func testCanGoToPrevious() async {
        let mockService = MockVideoApiService()
        let sampleVideos = MockVideoApiService.createSampleVideos()
        mockService.videosToReturn = sampleVideos
        
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        await viewModel.loadVideos()
        
        // At first video, can't go previous
        #expect(viewModel.canGoToPrevious == false)
        
        // Move to second video
        viewModel.currentVideoIndex = 1
        #expect(viewModel.canGoToPrevious == true)
        
        // Move to third video
        viewModel.currentVideoIndex = 2
        #expect(viewModel.canGoToPrevious == true)
    }
    
    //Check next action
    @Test func testCanGoToNext() async {
        let mockService = MockVideoApiService()
        let sampleVideos = MockVideoApiService.createSampleVideos()
        mockService.videosToReturn = sampleVideos
        
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        await viewModel.loadVideos()
        
        // At first video, can go next
        #expect(viewModel.canGoToNext == true)
        
        // Move to second video
        viewModel.currentVideoIndex = 1
        #expect(viewModel.canGoToNext == true)
        
        // Move to last video
        viewModel.currentVideoIndex = 2
        #expect(viewModel.canGoToNext == false)
    }
    
    //Check previous action on empty array
    @Test func testCanGoToPreviousWithEmptyVideos() async {
        let mockService = MockVideoApiService()
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        
        #expect(viewModel.canGoToPrevious == false)
    }
    
    //Check next action on empty array
    @Test func testCanGoToNextWithEmptyVideos() async {
        let mockService = MockVideoApiService()
        let viewModel = VideoPlayerViewModel(videoApiService: mockService, autoLoad: false)
        
        #expect(viewModel.canGoToNext == false)
    }
    

   
}

