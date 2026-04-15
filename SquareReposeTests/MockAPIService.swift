//
//  MockAPIService.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import Foundation
@testable import SquareRepose


final class MockAPIService: APIServiceProtocol {

    var shouldFail = false
    var shouldReturnEmpty = false
    var mockRepos: [Repo] = []

    func fetchRepos(
        page: Int,
        completion: @escaping (Result<[Repo], AppError>) -> Void
    ) {

        if shouldFail {
            completion(.failure(.networkError))
            return
        }

        if shouldReturnEmpty {
            completion(.success([]))
            return
        }

        completion(.success(mockRepos))
    }
}
