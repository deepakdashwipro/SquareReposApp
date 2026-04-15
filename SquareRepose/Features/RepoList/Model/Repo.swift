//
//  Repo.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import Foundation

// MARK: - Repo Model

/// Represents a GitHub repository from the Square organization API.
struct Repo: Codable, Hashable {

    /// Unique identifier of the repository
    let id: Int

    /// Repository name
    let name: String

    /// Optional description of the repository
    let description: String?

    /// URL to open repository in browser
    let htmlURL: String

    /// Number of stars
    let stargazersCount: Int

    /// Primary programming language used
    let language: String?

    /// Owner information (contains avatar)
    let owner: Owner

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case owner
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
    }
}

// MARK: - Owner Model

/// Represents repository owner details.
struct Owner: Codable, Hashable {

    /// Avatar image URL of the repository owner
    let avatarURL: String

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
