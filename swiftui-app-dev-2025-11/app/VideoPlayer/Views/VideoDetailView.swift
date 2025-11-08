//
//  VideoDetailView.swift
//  VideoPlayer
//
//  Created by Ritu on 2025-11-07.
//

import SwiftUI
import MarkdownUI

struct VideoDetailsView: View {
    let video: Video?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let video = video {
                    // Title
                    Text(video.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .accessibilityIdentifier("videoTitle")
                    
                    // Author
                    Text("By \(video.author.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .accessibilityIdentifier("videoAuthor")
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Description (Markdown)
                    Markdown(video.description)
                        .padding(.horizontal)
                        .accessibilityIdentifier("videoDescription")
                } else {
                    Text("No video selected")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .padding(.vertical)
        }
    }
}

