//
//  ImageLoader.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import UIKit

/// Responsible for downloading and caching images.
/// Uses in-memory caching to improve performance and reduce network calls.
final class ImageLoader {

    // MARK: - Singleton

    /// Shared instance for global usage
    static let shared = ImageLoader()

    private init() {}

    // MARK: - Properties

    /// In-memory image cache
    private let cache = NSCache<NSString, UIImage>()

    private let session: URLSession = .shared

    // MARK: - Public Methods

    /**
     Loads image from a given URL string.

     - Parameters:
        - urlString: Image URL as string
        - completion: Returns downloaded or cached UIImage
     */
    func loadImage(
        from urlString: String,
        completion: @escaping (UIImage?) -> Void
    ) {

        // ✅ Return cached image if available
        if let cached = cache.object(forKey: urlString as NSString) {
            completion(cached)
            return
        }

        // ✅ Validate URL
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        // MARK: - Network Call

        session.dataTask(with: url) { [weak self] data, _, error in

            // ❌ Network error
            if error != nil {
                self?.dispatch {
                    completion(nil)
                }
                return
            }

            // ❌ Invalid data
            guard let data = data,
                  let image = UIImage(data: data) else {
                self?.dispatch {
                    completion(nil)
                }
                return
            }

            // ✅ Cache image
            self?.cache.setObject(image, forKey: urlString as NSString)

            // ✅ Return on main thread
            self?.dispatch {
                completion(image)
            }

        }.resume()
    }

    // MARK: - Helpers

    /// Ensures UI updates happen on main thread
    private func dispatch(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}
