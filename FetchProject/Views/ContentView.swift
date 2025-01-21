//
//  ContentView.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import SwiftUI

/// The main content view of the application that displays a list of recipes.
///
/// This view presents a navigable list of recipes with the following features:
/// - A list of recipes with thumbnail images and basic information
/// - Navigation to detailed recipe views
/// - Pull to refresh functionality
/// - Error handling with alert dialogs
/// - Automatic loading of recipes on appearance
///
/// The recipe list items show:
/// - A small thumbnail image
/// - Recipe name
/// - Cuisine type
///
/// Usage:
/// ```swift
/// ContentView()
/// ```
struct ContentView: View {
    @StateObject private var viewModel = RecipeViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    HStack {
                        AsyncImage(url: recipe.photoURLSmall) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline)
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.loadRecipes()
            }
            .refreshable {
                await viewModel.loadRecipes()
            }
            .alert(item: $viewModel.errorMessage) { appError in
                Alert(
                    title: Text("Error"),
                    message: Text(appError.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

/// A model representing an error that can be displayed in an alert.
///
/// This struct conforms to `Identifiable` to enable its use with SwiftUI's alert presentation system.
///
/// Properties:
/// - id: A unique identifier for the error
/// - message: The error message to display to the user
struct AppError: Identifiable {
    let id = UUID()
    let message: String
}

#Preview {
    ContentView()
}
