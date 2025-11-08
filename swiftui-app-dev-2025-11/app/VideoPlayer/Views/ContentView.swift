//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Michael Gauthier on 2025-10-31.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VideoPlayerViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Video player at the top
            VideoPlayerView(viewModel: viewModel)
            
            // Scrollable details 
            VideoDetailsView(video: viewModel.currentVideo)
            
            // Show error message at bottom if present
            if let errorMessage = viewModel.errorMessage, !viewModel.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.title)
                    
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        Task {
                            await viewModel.loadVideos()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Retry")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(white: 0.95))
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .task {
            // Ensure videos are loaded when view appears
            if viewModel.videos.isEmpty && !viewModel.isLoading {
                await viewModel.loadVideos()
            }
        }
    }
}

#Preview {
    ContentView()
}
