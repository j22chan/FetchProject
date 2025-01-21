//
//  RecipeDetailView.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import SwiftUI
import WebKit

/// A view that displays detailed information about a recipe.
///
/// This view presents a comprehensive layout of recipe details including:
/// - A large header image that can be tapped to view the recipe source
/// - The recipe name and cuisine type overlaid on the header with shadow effects
/// - An embedded YouTube video player if a video URL is available
///
/// The view supports interactive elements like:
/// - Tapping the header image to open the recipe source in a web browser view
/// - Playing embedded YouTube content directly in the app
/// - Scrollable content for better navigation
///
/// The header image section features:
/// - Asynchronous image loading with a loading indicator
/// - Overlay text showing recipe name and cuisine type
/// - Shadow effects for better text visibility
/// - Tap gesture to open the recipe's source website
///
/// Usage:
/// ```swift
/// RecipeDetailView(recipe: recipeInstance)
/// ```
///
/// The web view is presented as a sheet with a large presentation detent
/// when the header image is tapped and a source URL is available.
struct RecipeDetailView: View {
    /// The recipe to display.
    let recipe: Recipe
    @State private var isShowingWebView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header section with tappable recipe image and overlay text
                if let photoURLLarge = recipe.photoURLLarge {
                    Button(action: {
                        // Open web view only if source URL exists
                        if recipe.sourceURL != nil {
                            print("Header tapped, showing web view.")
                            isShowingWebView = true
                        } else {
                            print("No source URL available.")
                        }
                    }) {
                        // Asynchronously load and display the recipe image
                        AsyncImage(url: photoURLLarge) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            // Show loading indicator while image loads
                            ProgressView()
                        }
                        .frame(height: 250)
                        .clipped()
                        .overlay(
                            // Recipe title and cuisine overlay with shadow effect
                            VStack(alignment: .leading) {
                                Text(recipe.name)
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white.opacity(0.9))
                                    .shadow(radius: 4)
                                Text(recipe.cuisine)
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.9))
                                    .shadow(radius: 4)
                            }
                            .padding(),
                            alignment: .bottomLeading
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                // Optional YouTube video section
                if let youtubeURL = recipe.youtubeURL {
                    YouTubePlayerView(youtubeURL: youtubeURL)
                        .frame(height: 300)
                        .padding()
                }
            }
        }
        // Configure navigation and web view presentation
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingWebView) {
            // Present web view sheet when source URL is available
            if let sourceURL = recipe.sourceURL {
                WebView(url: sourceURL)
                    .presentationDetents([.large])
            }
        }
    }
}


