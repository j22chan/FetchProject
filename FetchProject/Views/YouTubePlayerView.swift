//
//  YouTubePlayerView.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import SwiftUI
import WebKit

/// A SwiftUI view that wraps a WKWebView to display YouTube videos
/// This view conforms to UIViewRepresentable to bridge UIKit's WKWebView with SwiftUI
struct YouTubePlayerView: UIViewRepresentable {
    /// The URL of the YouTube video to be played
    let youtubeURL: URL
    
    /// Creates and returns a WKWebView instance
    /// - Parameter context: The context in which the view is being created
    /// - Returns: A new WKWebView instance
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    /// Updates the WKWebView with the YouTube video URL
    /// - Parameters:
    ///   - uiView: The WKWebView instance to update
    ///   - context: The context in which the view is being updated
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: youtubeURL)
        print(youtubeURL)
        uiView.load(request)
    }
}
