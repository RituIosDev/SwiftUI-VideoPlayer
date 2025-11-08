//
//  VideoApiService.swift
//  VideoPlayer
//
//  Created by Ritu on 2025-11-07.
//

import Foundation
//Useful for testing
protocol VideoApiServiceProtocol {
    func fetchVideos() async throws -> [Video]
}

class VideoApiService: VideoApiServiceProtocol {
    //127.0.0.1 for localhost on simulator.
    private let baseURL = "http://127.0.0.1:4000"
    
    // Fetch data from local host and sort according to date
    func fetchVideos() async throws -> [Video] {
        let urlString = "\(baseURL)/videos"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            throw URLError(.badURL)
        }
                
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    throw URLError(.badServerResponse)
                }
            }
            
            let videos = try JSONDecoder().decode([Video].self, from: data)
            // Sort videos by published date (most recent first)
            return videos.sorted { video1, video2 in
                guard let date1 = video1.publishedDate,
                      let date2 = video2.publishedDate else {
                    return false
                }
                return date1 > date2
            }
        } catch {
            throw error
        }
    }
}
