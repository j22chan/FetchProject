//
//  RecipeService.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import Foundation

/// A service class responsible for fetching recipe data from a remote API.
///
/// This class provides functionality to retrieve recipe data from a cloud-hosted JSON endpoint
/// and parse it into strongly-typed `Recipe` objects.
///
/// Usage:
/// ```swift
/// let service = RecipeService()
/// do {
///     let recipes = try await service.fetchRecipes()
///     // Process retrieved recipes
/// } catch {
///     // Handle error
/// }
/// ```
final class RecipeService: RecipeServiceProtocol {
    // Move URL to a static configuration or environment
    private static let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    private let recipesURL: URL
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder

    /// Initializes the service with a custom session and JSON decoder.
    /// - Parameters:
    ///   - session: URLSession interface for network requests. Defaults to `URLSession.shared`
    ///   - decoder: JSONDecoder for parsing response. Defaults to a new instance
    ///   - baseURL: Base URL for the API. Defaults to production URL
    init(
        session: URLSessionProtocol = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        baseURL: String = RecipeService.baseURL
    ) {
        self.session = session
        self.decoder = decoder
        self.recipesURL = URL(string: "\(baseURL)/recipes.json")!
    }

    func fetchRecipes() async throws -> [Recipe] {
        let (data, response) = try await session.data(from: recipesURL)
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw RecipeError.invalidResponse
        }
        
        let decodedData = try decoder.decode([String: [Recipe]].self, from: data)
        guard let recipes = decodedData["recipes"] else {
            throw RecipeError.missingData
        }
        return recipes
    }
}

// Add custom error enum
enum RecipeError: Error {
    case invalidResponse
    case missingData
}
