//
//  RecipeServiceTests.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import XCTest
@testable import FetchProject

final class RecipeServiceTests: XCTestCase {
    
    var recipeService: RecipeService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        recipeService = RecipeService(session: mockSession)
    }
    
    override func tearDown() {
        recipeService = nil
        mockSession = nil
        super.tearDown()
    }
    
    /// Tests that the `fetchRecipes` method successfully decodes valid recipe data.
    func testFetchRecipesSuccessfullyDecodesData() async throws {
        // Given
        let mockJSON = """
        {
            "recipes": [
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Spaghetti Carbonara",
                    "cuisine": "Italian",
                    "photo_url_small": "https://example.com/small.jpg",
                    "photo_url_large": "https://example.com/large.jpg",
                    "source_url": "https://example.com/recipe",
                    "youtube_url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
                }
            ]
        }
        """.data(using: .utf8)!
        
        mockSession.mockData = mockJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let recipes = try await recipeService.fetchRecipes()
        
        // Then
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.name, "Spaghetti Carbonara")
        XCTAssertEqual(recipes.first?.cuisine, "Italian")
    }
    
    /// Tests that `fetchRecipes` returns an empty array when the JSON data contains no recipes.
    func testFetchRecipesReturnsEmptyArrayForNoRecipes() async throws {
        // Given
        let mockJSON = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
        
        mockSession.mockData = mockJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let recipes = try await recipeService.fetchRecipes()
        
        // Then
        XCTAssertTrue(recipes.isEmpty, "Expected no recipes, but found some.")
    }
    
    /// Tests that `fetchRecipes` throws an error when the JSON is malformed.
    func testFetchRecipesThrowsErrorForMalformedJSON() async {
        // Given
        let mockJSON = """
        {
            "recipes": [
                { "invalid": "data" }
            ]
        }
        """.data(using: .utf8)!

        mockSession.mockData = mockJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then
        do {
            _ = try await recipeService.fetchRecipes()
            XCTFail("Expected an error to be thrown, but none was.")
        } catch {
            XCTAssertTrue(error is DecodingError, "Expected DecodingError, but got \(type(of: error)) instead.")
        }
    }
    
    /// Tests that `fetchRecipes` throws an error when the network request fails.
    func testFetchRecipesThrowsErrorForNetworkFailure() async {
        // Given
        mockSession.mockError = URLError(.notConnectedToInternet)
        recipeService = RecipeService(session: mockSession)
        
        // When/Then
        do {
            _ = try await recipeService.fetchRecipes()
            XCTFail("Expected an error to be thrown, but none was.")
        } catch {
            XCTAssertEqual(error as? URLError, URLError(.notConnectedToInternet))
        }
    }
    
    func testFetchRecipesThrowsErrorForMalformedRemoteJSON() async {
        // Given
        let mockJSON = """
        {
            "recipes": [
                {
                    "uuid": 123,  // Invalid type for UUID
                    "name": ["invalid"],  // Invalid type for string
                    "cuisine": null  // Missing required field
                }
            ]
        }
        """.data(using: .utf8)!

        mockSession.mockData = mockJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then
        do {
            _ = try await recipeService.fetchRecipes()
            XCTFail("Expected an error to be thrown, but none was.")
        } catch {
            XCTAssertTrue(error is DecodingError, "Expected DecodingError, but got \(type(of: error)) instead.")
        }
    }
}
