//
//  VideoPlayerViewModel.swift
//  VideoPlayer
//
//  Created by Ritu on 2025-11-07.
//


import Foundation
import AVKit
import Combine

@MainActor
class VideoPlayerViewModel: ObservableObject {
    // Initialize all variables
    @Published var videos: [Video] = []
    @Published var currentVideoIndex: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isPlaying: Bool = false
    
    private let videoApiService: VideoApiServiceProtocol
    var player: AVPlayer?
    private var playerTimeObserver: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(videoApiService: VideoApiServiceProtocol = VideoApiService(), autoLoad: Bool = true) {
        self.videoApiService = videoApiService
        //Load videos straight after initializing
        if autoLoad {
            Task {
                await loadVideos()
            }
        }
    }
    
    //Call and load videos from service
    func loadVideos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedVideos = try await videoApiService.fetchVideos()
            videos = fetchedVideos
            
            // Reset index when videos array changes
            if currentVideoIndex >= videos.count {
                currentVideoIndex = 0
            }
            
            // Load the first video by default
            if !videos.isEmpty {
                loadVideo(at: 0)
            } else {
                // Clear player if no videos
                player = nil
                currentVideoIndex = 0
                errorMessage = "No videos available"
            }
        } catch let error as URLError {
            // Handle network errors specifically
            errorMessage = "Network error: \(error.localizedDescription)\n\nError code: \(error.code.rawValue)"

            videos = []
            player = nil
            currentVideoIndex = 0
        } catch {
            errorMessage = "Failed to load videos\n\n\(error.localizedDescription)"
            videos = []
            player = nil
            currentVideoIndex = 0
        }
        
        isLoading = false
    }

    //Load video in player
    func loadVideo(at index: Int, shouldAutoPlay: Bool = false){
        guard index >= 0 && index < videos.count else { 
            currentVideoIndex = 0
            return 
        }
        
        // Store current playing state before switching
        let wasPlaying = isPlaying
        
        // Stop and cleanup previous player
        if let oldPlayer = player {
            oldPlayer.pause()
            oldPlayer.replaceCurrentItem(with: nil)
        }
        
        //Cancel previous observers
        playerTimeObserver?.cancel()
        cancellables.removeAll()
        
        currentVideoIndex = index
        let video = videos[index]
        
        //Load current video from Url to player
        guard let url = URL(string: video.hlsURL) else { 
            errorMessage = "Invalid video URL: \(video.hlsURL)"
            player = nil
            return 
        }
        
        let playerItem = AVPlayerItem(url: url)
        
        // Observe player item errors using Combine
        NotificationCenter.default.publisher(for: .AVPlayerItemFailedToPlayToEndTime, object: playerItem)
            .sink { [weak self] notification in
                Task { @MainActor in
                    if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
                        self?.errorMessage = "Video playback error: \(error.localizedDescription)"
                    }
                }
            }
            .store(in: &cancellables)
        
        // Reuse existing player or create new one
        if let existingPlayer = player {
            existingPlayer.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        //Observer player state change
        observePlayerState()
        
        // Determine if we should auto-play
        let shouldPlay = shouldAutoPlay || (index == 0 && videos.count > 0) || wasPlaying
        
        if shouldPlay {
            // Small delay to ensure player item is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.player?.play()
                self?.isPlaying = true
            }
        } else {
            player?.pause()
            isPlaying = false
        }
    }
    

    //Return current video
    var currentVideo: Video?{
        guard currentVideoIndex >= 0 && currentVideoIndex < videos.count else {
            return nil
        }
        return videos[currentVideoIndex]
    }
    
    //On previouse video action
    var canGoToPrevious: Bool {
        !videos.isEmpty && currentVideoIndex > 0
    }
    
    //On next video action
    var canGoToNext: Bool {
        !videos.isEmpty && currentVideoIndex < videos.count - 1
    }
    
    //Observe Player State
    private func observePlayerState() {
        guard let player else { return }
        
        playerTimeObserver = player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                Task { @MainActor in
                    self?.isPlaying = (status == .playing)
                }
            }
    }
    
    ///Play, Pause, Next, Previous Actions
    ///
    func playPause() {
        guard let player = player else { return }
        
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func goToNext() {
        guard canGoToNext else { return }
        loadVideo(at: currentVideoIndex + 1, shouldAutoPlay: isPlaying)
    }
    
    func goToPrevious() {
        guard canGoToPrevious else { return }
        loadVideo(at: currentVideoIndex - 1, shouldAutoPlay: isPlaying)
    }


}


    

    

    

