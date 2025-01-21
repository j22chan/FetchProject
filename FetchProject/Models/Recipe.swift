//
//  Recipe.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import Foundation

/// A model representing a recipe with its associated metadata.
///
/// This struct conforms to `Identifiable` for unique identification and `Decodable` for JSON parsing.
///
/// Properties:
/// - id: A unique identifier for the recipe
/// - name: The name of the recipe
/// - cuisine: The type of cuisine this recipe belongs to
/// - photoURLSmall: URL for a small photo of the recipe, if available
/// - photoURLLarge: URL for a large photo of the recipe, if available
/// - sourceURL: URL to the original recipe source, if available
/// - youtubeURL: URL to a related YouTube video, if available
struct Recipe: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let sourceURL: URL?
    let youtubeURL: URL?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
