//
//  RecipeViewModel.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import Foundation

/// A view model that manages recipe data and state for the UI.
///
/// This class handles loading recipes from the `RecipeService` and maintains the current state
/// of the recipe list and any error conditions. It conforms to `ObservableObject` to enable
/// SwiftUI view updates when the data changes.
///
/// Properties:
/// - recipes: An array of Recipe objects representing the currently loaded recipes
/// - errorMessage: An optional AppError that contains any error message to display
///
/// Usage:
/// ```swift
/// let viewModel = RecipeViewModel()
/// Task {
///     await viewModel.loadRecipes()
/// }
/// ```
@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: AppError?
    @Published var isLoading = false

    private let service: RecipeServiceProtocol

    init(service: RecipeServiceProtocol = RecipeService()) {
        self.service = service
    }

    func loadRecipes() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let fetchedRecipes = try await service.fetchRecipes()
            recipes = fetchedRecipes
        } catch RecipeError.invalidResponse {
            errorMessage = AppError(message: "Invalid server response. Please try again later.")
        } catch RecipeError.missingData {
            errorMessage = AppError(message: "Unable to load recipes data.")
        } catch {
            errorMessage = AppError(message: "Failed to load recipes. Please check your connection.")
        }
    }
}
