//
//  RepoCell.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import UIKit

/// Custom cell to display repository details with card UI, animations, and shimmer loading.
final class RepoCell: UITableViewCell {

    // MARK: - Identifier

    static let identifier = "RepoCell"

    // MARK: - UI Components

    private let cardView = UIView()

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let starLabel = UILabel()
    private let languageLabel = UILabel()
    private let languageContainer = UIView()

    private let highlightView = UIView()

    // MARK: - Skeleton

    private let shimmerLayer = CAGradientLayer()
    private var isSkeletonActive = false

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTapAnimation()
        setupShimmer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        setupCardView()
        setupAvatar()
        setupLabels()
        setupLayout()
        setupHighlight()
    }

    private func setupCardView() {
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 14
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray4.cgColor

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 6

        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
    }

    private func setupAvatar() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .systemGray5
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLabels() {
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .label

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2

        starLabel.font = .systemFont(ofSize: 13, weight: .medium)
        starLabel.textColor = .secondaryLabel

        languageContainer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        languageContainer.layer.cornerRadius = 6

        languageLabel.font = .systemFont(ofSize: 12, weight: .medium)
        languageLabel.textColor = .systemBlue

        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageContainer.translatesAutoresizingMaskIntoConstraints = false

        languageContainer.addSubview(languageLabel)

        NSLayoutConstraint.activate([
            languageLabel.topAnchor.constraint(equalTo: languageContainer.topAnchor, constant: 4),
            languageLabel.bottomAnchor.constraint(equalTo: languageContainer.bottomAnchor, constant: -4),
            languageLabel.leadingAnchor.constraint(equalTo: languageContainer.leadingAnchor, constant: 8),
            languageLabel.trailingAnchor.constraint(equalTo: languageContainer.trailingAnchor, constant: -8)
        ])
    }

    private func setupLayout() {
        let bottomStack = UIStackView(arrangedSubviews: [starLabel, languageContainer])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 10

        let textStack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, bottomStack])
        textStack.axis = .vertical
        textStack.spacing = 8

        let mainStack = UIStackView(arrangedSubviews: [avatarImageView, textStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .top
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),

            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupHighlight() {
        highlightView.backgroundColor = UIColor.label.withAlphaComponent(0.08)
        highlightView.layer.cornerRadius = 14
        highlightView.alpha = 0
        highlightView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(highlightView)

        NSLayoutConstraint.activate([
            highlightView.topAnchor.constraint(equalTo: cardView.topAnchor),
            highlightView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            highlightView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            highlightView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        shimmerLayer.frame = cardView.bounds
    }

    // MARK: - Configure

    func configure(with repo: Repo) {
        hideSkeleton()

        nameLabel.text = repo.name
        descriptionLabel.text = repo.description ?? "No description available"
        starLabel.text = "⭐ \(repo.stargazersCount)"

        if let language = repo.language {
            languageLabel.text = language
            languageContainer.isHidden = false
        } else {
            languageContainer.isHidden = true
        }

        avatarImageView.image = nil

        ImageLoader.shared.loadImage(from: repo.owner.avatarURL) { [weak self] image in
            self?.avatarImageView.image = image
        }
    }

    // MARK: - Tap Animation

    private func setupTapAnimation() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
        gesture.minimumPressDuration = 0
        gesture.cancelsTouchesInView = false
        cardView.addGestureRecognizer(gesture)
    }

    @objc private func handlePress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.15) {
                self.cardView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                self.highlightView.alpha = 1
            }
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.8) {
                self.cardView.transform = .identity
                self.highlightView.alpha = 0
            }
        default:
            break
        }
    }

    // MARK: - Skeleton (Shimmer)

    private func setupShimmer() {
        shimmerLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
    }

    func showSkeleton() {
        guard !isSkeletonActive else { return }
        isSkeletonActive = true

        cardView.layer.addSublayer(shimmerLayer)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity

        shimmerLayer.add(animation, forKey: "shimmer")
    }

    func hideSkeleton() {
        isSkeletonActive = false
        shimmerLayer.removeAllAnimations()
        shimmerLayer.removeFromSuperlayer()
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        hideSkeleton()
    }
}
