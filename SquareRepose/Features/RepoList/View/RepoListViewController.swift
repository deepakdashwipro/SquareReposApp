//
//  RepoListViewController.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import UIKit
import SafariServices

/// Displays list of repositories with pagination, loading states and error handling.
final class RepoListViewController: UIViewController {

    // MARK: - UI Components

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    private let initialLoader = InitialLoaderView()

    // MARK: - ViewModel

    private let viewModel = RepoListViewModel()

    // MARK: - State

    private var isShowingError = false
    private var isPaginating = false

    private let paginationThreshold = 3

    // MARK: - Empty State

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "tray"))
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No repositories found"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Square Repos"

        setupUI()
        setupBindings()

        viewModel.fetchInitial()
    }

    // MARK: - Setup

    private func setupUI() {
        addBackgroundGradient()
        setupTableView()
        setupLoader()
        setupInitialLoader()
        setupEmptyState()
    }

    private func addBackgroundGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.systemGray6.cgColor
        ]
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear

        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self

        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.identifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)

        tableView.separatorStyle = .none

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
    }

    private func setupLoader() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    private func setupInitialLoader() {
        initialLoader.frame = view.bounds
        view.addSubview(initialLoader)
    }

    private func setupEmptyState() {
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            emptyImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyImageView.heightAnchor.constraint(equalToConstant: 60),

            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 12),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Bindings

    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleState(state)
            }
        }
    }

    private func handleState(_ state: ViewState) {
        switch state {

        case .loading:
            activityIndicator.startAnimating()
            hideEmptyState()

        case .loaded:
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            isPaginating = false
            initialLoader.hide()
            hideEmptyState()
            tableView.reloadData()

        case .empty:
            initialLoader.hide()
            activityIndicator.stopAnimating()
            showEmptyState()
            tableView.reloadData()

        case .error(let message):
            initialLoader.hide()
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            showError(message)

        case .paginationLoading:
            isPaginating = true
            tableView.reloadData()
        }
    }

    // MARK: - Actions

    @objc private func refresh() {
        APIService.shared.clearCache()
        viewModel.fetchInitial()
    }

    private func showError(_ message: String) {
        guard !isShowingError else { return }
        isShowingError = true

        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            self.isShowingError = false
            self.viewModel.fetchInitial()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.isShowingError = false
        })

        present(alert, animated: true)
    }

    private func showEmptyState() {
        emptyLabel.isHidden = false
        emptyImageView.isHidden = false
    }

    private func hideEmptyState() {
        emptyLabel.isHidden = true
        emptyImageView.isHidden = true
    }
}

// MARK: - UITableViewDataSource

extension RepoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.repos.count
        return isPaginating ? count + 1 : count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isPaginating && indexPath.row == viewModel.repos.count {
            return tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath)
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier, for: indexPath) as? RepoCell else {
            return UITableViewCell()
        }

        cell.configure(with: viewModel.repos[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RepoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard indexPath.row < viewModel.repos.count else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let repo = viewModel.repos[indexPath.row]

        guard let url = URL(string: repo.htmlURL) else { return }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {

        // Animation
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 20)

        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.transform = .identity
        }

        // Pagination trigger
        let lastIndex = viewModel.repos.count - 1
        if indexPath.row == lastIndex {
            viewModel.fetchNextPage()
        }
    }
}

// MARK: - Prefetching

extension RepoListViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        let lastIndex = viewModel.repos.count - 1

        if indexPaths.contains(where: { $0.row >= lastIndex - paginationThreshold }) {
            viewModel.fetchNextPage()
        }
    }
}
