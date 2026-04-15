//
//  RepoListViewModelTests.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//
import XCTest
@testable import SquareRepose

final class RepoListViewModelTests: XCTestCase {

    private var viewModel: RepoListViewModel!
    private var mockService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = RepoListViewModel(apiService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Success Case

    func testFetchInitialSuccess() {

        let expectation = XCTestExpectation(description: "Initial fetch success")

        let repo = Repo(
            id: 1,
            name: "Repo1",
            description: "Test Repo",
            htmlURL: "https://github.com",
            stargazersCount: 10,
            language: "Swift",
            owner: Owner(avatarURL: "")
        )

        mockService.mockRepos = [repo]

        viewModel.onStateChange = { state in
            if case .loaded(let repos) = state {
                XCTAssertEqual(repos.count, 1)
                expectation.fulfill()
            }
        }

        viewModel.fetchInitial()

        wait(for: [expectation], timeout: 2)
    }

    // MARK: - Empty State

    func testFetchEmpty() {

        let expectation = XCTestExpectation(description: "Empty state")

        mockService.shouldReturnEmpty = true

        viewModel.onStateChange = { state in
            if case .empty = state {
                expectation.fulfill()
            }
        }

        viewModel.fetchInitial()

        wait(for: [expectation], timeout: 2)
    }

    // MARK: - Error State (First Load)

    func testFetchFailureFirstPage() {

        let expectation = XCTestExpectation(description: "Failure state")

        mockService.shouldFail = true

        viewModel.onStateChange = { state in
            if case .error(let message) = state {
                XCTAssertFalse(message.isEmpty)
                expectation.fulfill()
            }
        }

        viewModel.fetchInitial()

        wait(for: [expectation], timeout: 2)
    }

    // MARK: - Pagination Success

    func testPaginationSuccess() {

        let expectation = XCTestExpectation(description: "Pagination success")

        let firstPage = [
            Repo(id: 1, name: "Repo1", description: nil,
                 htmlURL: "", stargazersCount: 1,
                 language: "Swift", owner: Owner(avatarURL: ""))
        ]

        let secondPage = [
            Repo(id: 2, name: "Repo2", description: nil,
                 htmlURL: "", stargazersCount: 2,
                 language: "Swift", owner: Owner(avatarURL: ""))
        ]

        mockService.mockRepos = firstPage

        var callCount = 0

        viewModel.onStateChange = { state in

            if case .loaded(let repos) = state {

                callCount += 1

                if callCount == 1 {
                    XCTAssertEqual(repos.count, 1)

                    // Next page
                    self.mockService.mockRepos = secondPage
                    self.viewModel.fetchNextPage()

                } else if callCount == 2 {
                    XCTAssertEqual(repos.count, 2)
                    expectation.fulfill()
                }
            }
        }

        viewModel.fetchInitial()

        wait(for: [expectation], timeout: 3)
    }

    // MARK: - Retry After Failure

    func testRetryAfterFailure() {

        let expectation = XCTestExpectation(description: "Retry works")

        mockService.shouldFail = true

        var didFail = false

        viewModel.onStateChange = { state in

            if case .error = state, !didFail {
                didFail = true

                // Fix mock and retry
                self.mockService.shouldFail = false
                self.mockService.mockRepos = [
                    Repo(id: 1, name: "RetryRepo", description: nil,
                         htmlURL: "", stargazersCount: 5,
                         language: "Swift", owner: Owner(avatarURL: ""))
                ]

                self.viewModel.retry()

            } else if case .loaded(let repos) = state {
                XCTAssertEqual(repos.count, 1)
                expectation.fulfill()
            }
        }

        viewModel.fetchInitial()

        wait(for: [expectation], timeout: 3)
    }
}
