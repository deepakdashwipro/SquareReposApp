//
//  APIService.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import Foundation

/// Responsible for handling all API network requests.
/// Implements caching and error handling.
final class APIService: APIServiceProtocol {

    // MARK: - Singleton

    /// Shared instance for global access
    static let shared = APIService()

    private init() {}

    // MARK: - Properties

    /// In-memory cache (page → repos)
    private var repoCache: [Int: [Repo]] = [:]

    /// URLSession for network calls (injectable for testing)
    private let session: URLSession = .shared

    // MARK: - Public Methods

    /**
     Fetch repositories from API with pagination support.

     - Parameters:
        - page: Page number for pagination
        - completion: Completion handler with `Result<[Repo], AppError>`
     */
    func fetchRepos(
        page: Int,
        completion: @escaping (Result<[Repo], AppError>) -> Void
    ) {

        // ✅ Guard invalid page (fixes your earlier test issue too)
        guard page > 0 else {
            completion(.failure(.invalidURL))
            return
        }

        // ✅ Return cached data if available
        if let cached = repoCache[page] {
            completion(.success(cached))
            return
        }

        let urlString = "https://api.github.com/orgs/square/repos?page=\(page)&per_page=20"

        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: url, timeoutInterval: 15)

        session.dataTask(with: request) { [weak self] data, response, error in

            // MARK: - Error Handling

            if error != nil {
                self?.dispatch {
                    completion(.failure(.networkError))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                self?.dispatch {
                    completion(.failure(.unknown))
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                self?.dispatch {
                    completion(.failure(.serverError))
                }
                return
            }

            guard let data = data else {
                self?.dispatch {
                    completion(.failure(.noData))
                }
                return
            }

            // MARK: - Parsing

            do {
                let repos = try JSONDecoder().decode([Repo].self, from: data)

                // ✅ Save to cache
                self?.repoCache[page] = repos

                self?.dispatch {
                    completion(.success(repos))
                }

            } catch {
                self?.dispatch {
                    completion(.failure(.decodingError))
                }
            }

        }.resume()
    }

    /// Clears in-memory cache (useful for pull-to-refresh)
    func clearCache() {
        repoCache.removeAll()
    }

    // MARK: - Helpers

    /// Ensures completion runs on main thread
    private func dispatch(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}
