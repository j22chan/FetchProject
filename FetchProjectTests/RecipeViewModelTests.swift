//
//  RecipeViewModelTests.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import XCTest
@testable import FetchProject

class MockRecipeService: RecipeServiceProtocol {
    var mockRecipes: [Recipe] = []
    var mockError: RecipeError?
    var shouldThrowError: Bool = false  // Maintain backward compatibility

    func fetchRecipes() async throws -> [Recipe] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        if let error = mockError {
            throw error
        }
        return mockRecipes
    }
}

@MainActor
final class RecipeViewModelTests: XCTestCase {

    var viewModel: RecipeViewModel!
    var mockService: MockRecipeService!

    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        viewModel = RecipeViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }


    /// Tests that the view model successfully loads recipes and updates its state.
    func testLoadRecipesSuccessfullyUpdatesRecipes() async {
        // Given
        let expectedRecipes = [
            Recipe(
                id: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!,
                name: "Spaghetti Carbonara",
                cuisine: "Italian",
                photoURLSmall: nil,
                photoURLLarge: nil,
                sourceURL: nil,
                youtubeURL: nil
            )
        ]
        mockService.mockRecipes = expectedRecipes

        // When
        await viewModel.loadRecipes()

        // Then
        XCTAssertEqual(viewModel.recipes, expectedRecipes, "Recipes should be updated correctly.")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil after successful load.")
    }

    /// Tests that the view model sets an error message when loading recipes fails.
    func testLoadRecipesSetsErrorOnFailure() async {
        // Given
        mockService.shouldThrowError = true

        // When
        await viewModel.loadRecipes()

        // Then
        XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty after a failed load.")
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set after a failed load.")
        XCTAssertEqual(viewModel.errorMessage?.message, "Failed to load recipes. Please check your connection.", "Error message should match expected text.")
    }

    /// Tests that the view model starts with an empty recipe list and no error message.
    func testInitialState() {
        // Given & When
        // No action needed; testing initial state.

        // Then
        XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty initially.")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil initially.")
    }

    /// Tests that the view model sets appropriate error messages for specific error cases.
    func testLoadRecipesSetsSpecificErrorMessages() async {
        // Test invalid response error
        mockService.mockError = .invalidResponse
        await viewModel.loadRecipes()
        XCTAssertEqual(viewModel.errorMessage?.message, "Invalid server response. Please try again later.")

        // Test missing data error
        mockService.mockError = .missingData
        await viewModel.loadRecipes()
        XCTAssertEqual(viewModel.errorMessage?.message, "Unable to load recipes data.")
    }
}
