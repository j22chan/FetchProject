//
//  RecipeTests.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import XCTest
@testable import FetchProject

final class RecipeTests: XCTestCase {

    /// Tests the successful decoding of a Recipe object from JSON with all fields present.
    /// This test verifies that:
    /// - All required and optional fields are correctly decoded
    /// - UUID is properly converted from string
    /// - URLs are properly formatted and created
    func testRecipeDecoding() throws {
        // JSON data representing a sample recipe
        let jsonData = """
        {
            "uuid": "123e4567-e89b-12d3-a456-426614174000",
            "name": "Spaghetti Carbonara",
            "cuisine": "Italian",
            "photo_url_small": "https://example.com/small.jpg",
            "photo_url_large": "https://example.com/large.jpg",
            "source_url": "https://example.com/recipe",
            "youtube_url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        }
        """.data(using: .utf8)!

        // Decode the JSON data into a Recipe instance
        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: jsonData)

        // Assertions to verify the decoded data
        XCTAssertEqual(recipe.id, UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000"))
        XCTAssertEqual(recipe.name, "Spaghetti Carbonara")
        XCTAssertEqual(recipe.cuisine, "Italian")
        XCTAssertEqual(recipe.photoURLSmall, URL(string: "https://example.com/small.jpg"))
        XCTAssertEqual(recipe.photoURLLarge, URL(string: "https://example.com/large.jpg"))
        XCTAssertEqual(recipe.sourceURL, URL(string: "https://example.com/recipe"))
        XCTAssertEqual(recipe.youtubeURL, URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"))
    }

    /// Tests the decoding of a Recipe object from JSON with only required fields present.
    /// This test verifies that:
    /// - Required fields (uuid, name, cuisine) are correctly decoded
    /// - Optional fields (photo URLs, source URL, youtube URL) default to nil when missing
    func testRecipeDecodingMissingFields() throws {
        // JSON data with missing optional fields
        let jsonData = """
        {
            "uuid": "123e4567-e89b-12d3-a456-426614174000",
            "name": "Margherita Pizza",
            "cuisine": "Italian"
        }
        """.data(using: .utf8)!

        // Decode the JSON data into a Recipe instance
        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: jsonData)

        // Assertions to verify the decoded data
        XCTAssertEqual(recipe.id, UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000"))
        XCTAssertEqual(recipe.name, "Margherita Pizza")
        XCTAssertEqual(recipe.cuisine, "Italian")
        XCTAssertNil(recipe.photoURLSmall)
        XCTAssertNil(recipe.photoURLLarge)
        XCTAssertNil(recipe.sourceURL)
        XCTAssertNil(recipe.youtubeURL)
    }

    /// Tests the error handling when attempting to decode a Recipe with an invalid UUID.
    /// This test verifies that:
    /// - An invalid UUID string triggers a DecodingError
    /// - The error is of type dataCorrupted
    /// - The error occurs in the correct coding path ("uuid")
    func testRecipeDecodingInvalidUUID() throws {
        // JSON data with an invalid UUID
        let jsonData = """
        {
            "uuid": "invalid-uuid",
            "name": "Caesar Salad",
            "cuisine": "Italian"
        }
        """.data(using: .utf8)!

        // Decode the JSON data into a Recipe instance
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Recipe.self, from: jsonData)) { error in
            guard case DecodingError.dataCorrupted(let context) = error else {
                return XCTFail("Expected dataCorrupted error")
            }
            XCTAssertEqual(context.codingPath.map { $0.stringValue }, ["uuid"])
        }
    }

    /// Tests that encoding a Recipe to JSON and then decoding it back results in an equivalent Recipe instance.
    func testRecipeEncodingDecodingConsistency() throws {
        let originalRecipe = Recipe(
            id: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!,
            name: "Consistent Recipe",
            cuisine: "International",
            photoURLSmall: URL(string: "https://example.com/small.jpg"),
            photoURLLarge: URL(string: "https://example.com/large.jpg"),
            sourceURL: URL(string: "https://example.com/recipe"),
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        )

        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalRecipe)

        let decoder = JSONDecoder()
        let decodedRecipe = try decoder.decode(Recipe.self, from: encodedData)

        XCTAssertEqual(originalRecipe, decodedRecipe)
    }

    /// Tests that the Recipe struct can handle JSON with additional unknown fields gracefully.
    func testRecipeDecodingWithAdditionalFields() throws {
        let jsonData = """
        {
            "uuid": "123e4567-e89b-12d3-a456-426614174000",
            "name": "Extra Fields Recipe",
            "cuisine": "Experimental",
            "unknown_field": "some value"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: jsonData)

        XCTAssertEqual(recipe.id, UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000"))
        XCTAssertEqual(recipe.name, "Extra Fields Recipe")
        XCTAssertEqual(recipe.cuisine, "Experimental")
    }
}
