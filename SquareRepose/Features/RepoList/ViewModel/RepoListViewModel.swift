//
//  RepoListViewModel.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import Foundation

/// ViewModel responsible for handling repository data,
/// pagination, and UI state management.
final class RepoListViewModel {

    // MARK: - Dependencies

    /// Abstracted API service (supports mocking for tests)
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    // MARK: - Data

    /// List of repositories displayed in UI
    private(set) var repos: [Repo] = []

    // MARK: - State

    /// Callback to notify UI about state changes
    var onStateChange: ((ViewState) -> Void)?

    private var currentPage = 1
    private var isLoading = false
    private var hasMoreData = true

    // MARK: - Initial Load

    /// Fetch first page of data
    func fetchInitial() {
        currentPage = 1
        repos.removeAll()
        hasMoreData = true

        onStateChange?(.loading)
        fetchRepos()
    }

    // MARK: - Pagination

    /// Fetch next page if available
    func fetchNextPage() {
        guard !isLoading && hasMoreData else { return }

        onStateChange?(.paginationLoading)
        fetchRepos()
    }

    // MARK: - Core API Call

    /// Handles API request and state updates
    private func fetchRepos() {
        isLoading = true

        apiService.fetchRepos(page: currentPage) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {

            case .success(let newRepos):

                // ❌ No more data
                if newRepos.isEmpty {
                    self.hasMoreData = false

                    if self.repos.isEmpty {
                        self.onStateChange?(.empty)
                    }
                    return
                }

                // ✅ Append new data
                self.repos.append(contentsOf: newRepos)

                // ✅ Increment page ONLY after success
                self.currentPage += 1

                self.onStateChange?(.loaded(self.repos))

            case .failure(let error):

                // ❌ First page failure
                if self.repos.isEmpty {
                    self.onStateChange?(.error(self.mapError(error)))
                } else {
                    // ✅ Keep existing data on pagination error
                    self.onStateChange?(.loaded(self.repos))
                }
            }
        }
    }

    // MARK: - Actions

    /// Retry last failed request
    func retry() {
        fetchRepos()
    }

    /// Pull-to-refresh action
    func refresh() {
        fetchInitial()
    }

    // MARK: - Error Mapping

    /// Converts AppError into user-friendly message
    private func mapError(_ error: AppError) -> String {
        return error.errorDescription ?? "Something went wrong"
    }
}
