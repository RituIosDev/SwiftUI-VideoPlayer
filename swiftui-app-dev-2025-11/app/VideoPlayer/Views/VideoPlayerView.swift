//
//  VideoPlayerView.swift
//  VideoPlayer
//
//  Created by Ritu on 2025-11-07.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @ObservedObject var viewModel: VideoPlayerViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Video player
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .frame(height: 250)
            } else {
                // Placeholder while loading
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 250)
                    .overlay {
                        if viewModel.isLoading {
                            VStack(spacing: 12) {
                                ProgressView()
                                    .tint(.white)
                                Text("Loading videos...")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        } else if let errorMessage = viewModel.errorMessage {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                                Text(errorMessage)
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        } else {
                            Text("No video available")
                                .foregroundColor(.white)
                        }
                    }
            }
            
            // Media controls
            HStack(spacing: 40) {
                // Previous button
                Button(action: {
                    viewModel.goToPrevious()
                }) {
                    Image("previous")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .disabled(!viewModel.canGoToPrevious)
                .opacity(viewModel.canGoToPrevious ? 1.0 : 0.5)
                .accessibilityIdentifier("previousButton")
                
                // Play/Pause button
                Button(action: {
                    viewModel.playPause()
                }) {
                    Image(viewModel.isPlaying ? "pause" : "play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .accessibilityIdentifier("playPauseButton")
                
                // Next button
                Button(action: {
                    viewModel.goToNext()
                }) {
                    Image("next")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .disabled(!viewModel.canGoToNext)
                .opacity(viewModel.canGoToNext ? 1.0 : 0.5)
                .accessibilityIdentifier("nextButton")
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(white: 0.95))
        }
    }
}

#Preview {
    VideoPlayerView(viewModel: VideoPlayerViewModel())
}
