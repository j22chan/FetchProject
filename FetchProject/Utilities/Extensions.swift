//
//  Extensions.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import Foundation

extension URLSession: URLSessionProtocol {}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

/// A protocol defining the contract for fetching recipes.
protocol RecipeServiceProtocol {
    /// Fetches an array of recipes asynchronously.
    /// - Returns: An array of `Recipe` objects.
    /// - Throws: An error if the fetch fails.
    func fetchRecipes() async throws -> [Recipe]
}
