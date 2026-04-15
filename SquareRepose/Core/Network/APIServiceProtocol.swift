//
//  APIServiceProtocol.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import Foundation

/// Abstraction for API layer.
/// Enables dependency injection and mocking for unit testing.
protocol APIServiceProtocol {

    /**
     Fetch repositories with pagination support.

     - Parameters:
        - page: Page number for API pagination
        - completion: Completion handler returning either
                      a list of `Repo` or an `AppError`
     */
    func fetchRepos(
        page: Int,
        completion: @escaping (Result<[Repo], AppError>) -> Void
    )
}
