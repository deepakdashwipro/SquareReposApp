//
//  AppDelegate.swift
//  SquareRepose
//
//  Created by Deepak Kumar Dash on 15/04/26.
//

import UIKit

/// Entry point of the application.
/// Responsible for app lifecycle and initial UI setup.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//
    // MARK: - Properties

    /// Main application window
    var window: UIWindow?

    // MARK: - App Lifecycle

    /**
     Called when the application has finished launching.

     - Parameters:
        - application: The singleton app object.
        - launchOptions: Launch configuration dictionary.

     - Returns: `true` if the app launched successfully.
     */
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupRootViewController()
        return true
    }

    // MARK: - Setup

    /// Configures and sets the root view controller of the app.
    private func setupRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)

        let repoListVC = RepoListViewController()
        let navigationController = UINavigationController(rootViewController: repoListVC)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
