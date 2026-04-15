//
//  APIServiceTests.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//
import XCTest
@testable import SquareRepose

final class APITests: XCTestCase {

    func testNetworkFailure() {
        let mockService = MockAPIService()
        mockService.shouldFail = true

        let expectation = XCTestExpectation(description: "Network failure")

        mockService.fetchRepos(page: 1) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .networkError)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2)
    }
}
