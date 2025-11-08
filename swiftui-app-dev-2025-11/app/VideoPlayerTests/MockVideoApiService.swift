//
//  MockVideoApiService.swift
//  VideoPlayerTests
//
//  Created by Ritu on 2025-11-07.
//

import Foundation
@testable import VideoPlayer

//Mock API Service Call
class MockVideoApiService: VideoApiServiceProtocol {
    var videosToReturn: [Video] = []
    var shouldThrowError: Error?
    var fetchVideosCallCount = 0
    
    func fetchVideos() async throws -> [Video] {
        fetchVideosCallCount += 1
        
        if let error = shouldThrowError {
            throw error
        }
        
        return videosToReturn
    }
    
    // Create Sample Video To return on Mock API call
    static func createSampleVideos() -> [Video] {
        let author1 = Author(id: "author1", name: "John Doe")
        let author2 = Author(id: "author2", name: "Jane Smith")
        
        let video1 = Video(
            id: "1",
            title: "First Video",
            hlsURL: "https://example.com/video1.m3u8",
            fullURL: "https://example.com/video1.mp4",
            description: "This is the first video",
            publishedAt: "2025-01-01T10:00:00Z",
            author: author1
        )
        
        let video2 = Video(
            id: "2",
            title: "Second Video",
            hlsURL: "https://example.com/video2.m3u8",
            fullURL: "https://example.com/video2.mp4",
            description: "This is the second video",
            publishedAt: "2025-01-02T10:00:00Z",
            author: author2
        )
        
        let video3 = Video(
            id: "3",
            title: "Third Video",
            hlsURL: "https://example.com/video3.m3u8",
            fullURL: "https://example.com/video3.mp4",
            description: "This is the third video",
            publishedAt: "2025-01-03T10:00:00Z",
            author: author1
        )
        
        return [video1, video2, video3]
    }
}

