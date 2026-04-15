//
//  LoadingCell.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import UIKit

/// A simple loading cell used for pagination (infinite scroll).
/// Displays a centered activity indicator.
final class LoadingCell: UITableViewCell {

    // MARK: - Identifier

    static let identifier = "LoadingCell"

    // MARK: - UI Components

    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        startLoading()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: - Public Methods

    /// Starts spinner animation
    func startLoading() {
        spinner.startAnimating()
    }

    /// Stops spinner animation
    func stopLoading() {
        spinner.stopAnimating()
    }

    // MARK: - Reuse Handling

    override func prepareForReuse() {
        super.prepareForReuse()
        startLoading() // ensure spinner is always active when reused
    }
}
