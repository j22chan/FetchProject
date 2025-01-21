//
//  ImageCache.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import Foundation
import SwiftUI

/// A singleton service that caches SwiftUI images in memory.
///
/// This class provides a simple in-memory caching mechanism for `SwiftUI.Image` objects,
/// indexed by their source URLs. It helps improve performance by avoiding repeated image
/// downloads and conversions by storing previously loaded images in memory.
///
/// The cache is cleared when the app is terminated or receives a memory warning.
///
/// Usage:
/// ```swift
/// let cache = ImageCache.shared
/// 
/// // Store an image in the cache
/// cache.setImage(someImage, for: imageURL)
/// 
/// // Retrieve a cached image
/// if let cachedImage = cache.image(for: imageURL) {
///     // Use the cached image
/// }
/// 
/// // Clear the entire cache if needed
/// cache.clearCache()
/// ```
///
/// - Important: This cache only persists images in memory and does not write to disk.
///   Images will need to be reloaded when the app restarts.
class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private var cache: [URL: Image] = [:]

    func image(for url: URL) -> Image? {
        return cache[url]
    }

    func setImage(_ image: Image, for url: URL) {
        cache[url] = image
    }

    /// Clears all images from the cache
    func clearCache() {
        cache.removeAll()
    }
}
