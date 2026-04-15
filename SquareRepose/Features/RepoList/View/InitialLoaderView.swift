//
//  Untitled.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import UIKit

/// A reusable full-screen loader view with animation.
/// Displays an icon and loading text while data is being fetched.
final class InitialLoaderView: UIView {

    // MARK: - UI Components

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    /// Configures UI elements and layout
    private func setupUI() {
        backgroundColor = .systemBackground

        setupImageView()
        setupLabel()
        setupConstraints()
    }

    private func setupImageView() {
        imageView.image = UIImage(systemName: "folder.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
    }

    private func setupLabel() {
        titleLabel.text = "Loading Repositories..."
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Animation

    /// Starts pulsing animation
    private func startAnimation() {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.85
        scale.toValue = 1.15
        scale.duration = 0.8
        scale.autoreverses = true
        scale.repeatCount = .infinity
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        imageView.layer.add(scale, forKey: "pulse")
    }

    /// Stops animation safely
    private func stopAnimation() {
        imageView.layer.removeAnimation(forKey: "pulse")
    }

    // MARK: - Public Methods

    /// Hides loader with fade-out animation
    func hide() {
        stopAnimation()

        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
