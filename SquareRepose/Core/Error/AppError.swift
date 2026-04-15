//
//  AppError.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import Foundation

/// Represents all possible errors in the application.
/// Conforms to `LocalizedError` for user-friendly messages
/// and `Equatable` for easy unit testing.
enum AppError: LocalizedError, Equatable {

    // MARK: - Error Cases

    case invalidURL
    case networkError
    case decodingError
    case serverError
    case noData
    case unknown

    // MARK: - Localized Description

    /// Human-readable error message for UI display
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .networkError:
            return "No internet connection. Please try again."
        case .decodingError:
            return "Failed to parse data."
        case .serverError:
            return "Server error. Please try later."
        case .noData:
            return "No data available."
        case .unknown:
            return "Something went wrong."
        }
    }
}
