//
//  ImageCacheTests.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import XCTest
import SwiftUI
@testable import FetchProject

final class ImageCacheTests: XCTestCase {

    var imageCache: ImageCache!

    override func setUp() {
        super.setUp()
        imageCache = .shared
        imageCache.clearCache() // Clear the cache before each test
    }

    override func tearDown() {
        imageCache.clearCache() // Clear the cache after each test
        imageCache = nil
        super.tearDown()
    }

    func renderedUIImage(from image: Image) -> UIImage? {
        let controller = UIHostingController(rootView: image)
        controller.view.bounds = CGRect(x: 0, y: 0, width: 100, height: 100) // Set a fixed size for rendering

        let renderer = UIGraphicsImageRenderer(size: controller.view.bounds.size)
        return renderer.image { context in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    /// Tests that an image can be stored and retrieved from the cache.
    func testSetImageAndRetrieve() {
        // Given
        let testImage = Image(systemName: "star")
        let testURL = URL(string: "https://example.com/image1.png")!

        // When
        imageCache.setImage(testImage, for: testURL)
        let retrievedImage = imageCache.image(for: testURL)

        // Then
        XCTAssertNotNil(retrievedImage, "Image should be retrieved from the cache.")

        let testUIImage = renderedUIImage(from: testImage)
        let retrievedUIImage = retrievedImage.flatMap { renderedUIImage(from: $0) }
        XCTAssertEqual(testUIImage?.pngData(), retrievedUIImage?.pngData(), "The retrieved image should match the stored image.")
    }

    /// Tests that retrieving an image for a URL not in the cache returns nil.
    func testRetrieveImageForNonExistentURL() {
        // Given
        let testURL = URL(string: "https://example.com/nonexistent.png")!

        // When
        let retrievedImage = imageCache.image(for: testURL)

        // Then
        XCTAssertNil(retrievedImage, "Retrieving an image for a non-existent URL should return nil.")
    }

    /// Tests that the cache is cleared successfully.
    func testClearCache() {
        // Given
        let testImage = Image(systemName: "heart")
        let testURL = URL(string: "https://example.com/image2.png")!
        imageCache.setImage(testImage, for: testURL)

        // When
        imageCache.clearCache()
        let retrievedImage = imageCache.image(for: testURL)

        // Then
        XCTAssertNil(retrievedImage, "Cache should be empty after clearing.")
    }

    /// Tests that setting an image for the same URL overwrites the existing image in the cache.
    func testOverwriteImageInCache() {
        // Given
        let initialImage = Image(systemName: "circle")
        let newImage = Image(systemName: "square")
        let testURL = URL(string: "https://example.com/image3.png")!

        // When
        imageCache.setImage(initialImage, for: testURL)
        imageCache.setImage(newImage, for: testURL)
        let retrievedImage = imageCache.image(for: testURL)

        // Then
        XCTAssertNotNil(retrievedImage, "Image should exist in the cache.")

        let initialUIImage = renderedUIImage(from: initialImage)
        let newUIImage = renderedUIImage(from: newImage)
        let retrievedUIImage = retrievedImage.flatMap { renderedUIImage(from: $0) }

        XCTAssertEqual(retrievedUIImage?.pngData(), newUIImage?.pngData(), "The new image should overwrite the old image in the cache.")
        XCTAssertNotEqual(retrievedUIImage?.pngData(), initialUIImage?.pngData(), "The retrieved image should not match the initial image after overwrite.")
    }

    /// Tests that the cache handles multiple entries correctly.
    func testCacheMultipleEntries() {
        // Given
        let image1 = Image(systemName: "pencil")
        let url1 = URL(string: "https://example.com/image4.png")!
        let image2 = Image(systemName: "scissors")
        let url2 = URL(string: "https://example.com/image5.png")!

        // When
        imageCache.setImage(image1, for: url1)
        imageCache.setImage(image2, for: url2)

        // Then
        let retrievedImage1 = imageCache.image(for: url1)
        let retrievedImage2 = imageCache.image(for: url2)

        XCTAssertNotNil(retrievedImage1, "Image 1 should exist in the cache.")
        XCTAssertNotNil(retrievedImage2, "Image 2 should exist in the cache.")

        let renderedImage1 = renderedUIImage(from: image1)
        let renderedImage2 = renderedUIImage(from: image2)
        let retrievedUIImage1 = retrievedImage1.flatMap { renderedUIImage(from: $0) }
        let retrievedUIImage2 = retrievedImage2.flatMap { renderedUIImage(from: $0) }

        XCTAssertEqual(retrievedUIImage1?.pngData(), renderedImage1?.pngData(), "Image 1 should be correctly cached.")
        XCTAssertEqual(retrievedUIImage2?.pngData(), renderedImage2?.pngData(), "Image 2 should be correctly cached.")
    }
}
