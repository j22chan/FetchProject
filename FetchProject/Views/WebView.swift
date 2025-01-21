//
//  WebView.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import SwiftUI
import WebKit

/// A SwiftUI view that wraps WKWebView to display web content.
/// This struct provides a bridge between SwiftUI and WKWebView, allowing web content
/// to be displayed within a SwiftUI view hierarchy.
struct WebView: UIViewRepresentable {
    /// The URL to load in the web view.
    /// If nil, the web view will remain empty.
    let url: URL?
    
    /// Creates and returns a WKWebView instance.
    /// - Parameter context: The context in which the web view is being created
    /// - Returns: A new WKWebView instance
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    /// Updates the web view's content when SwiftUI updates the view.
    /// - Parameters:
    ///   - uiView: The WKWebView instance to update
    ///   - context: The context in which the web view is being updated
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

