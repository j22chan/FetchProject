//
//  MockURLSession.swift
//  FetchProject
//
//  Created by Jimmy Chan on 1/18/25.
//

import Foundation

/// A mock implementation of `URLSessionProtocol` used for testing network requests.
///
/// This class allows tests to simulate network responses by providing mock data or errors
/// that will be returned when the `data` method is called.
///
/// Example usage:
/// ```swift
/// let mockSession = MockURLSession()
/// mockSession.mockData = testData
/// let result = try await mockSession.data(from: testURL)
/// ```
class MockURLSession: URLSessionProtocol {
    /// The mock data to return in the `data` method.
    /// If nil, an empty `Data` object will be returned.
    var mockData: Data?
    
    /// The mock error to throw in the `data` method.
    /// If set, this error will be thrown instead of returning data.
    var mockError: Error?
    
    /// The mock response to return in the `data` method.
    /// If nil, a default HTTPURLResponse will be returned.
    var mockResponse: URLResponse?

    /// Simulates a network request by returning mock data or throwing a mock error.
    /// - Parameter url: The URL for the simulated request
    /// - Returns: A tuple containing the mock data and a default URLResponse
    /// - Throws: The mock error if one is set
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        return (
            mockData ?? Data(),
            mockResponse ?? HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
    }
}

