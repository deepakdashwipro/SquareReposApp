//
//  ViewState.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import Foundation

/// Represents all possible UI states for the repository list screen.
/// Used by ViewModel to communicate with ViewController.
enum ViewState {

    /// Initial loading state (first API call)
    case loading

    /// Data successfully loaded
    case loaded([Repo])

    /// No data available
    case empty

    /// Error state with message
    case error(String)

    /// Pagination loading (bottom loader)
    case paginationLoading
}
