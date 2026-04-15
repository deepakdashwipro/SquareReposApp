# 📱 SquareReposApp

<p align="center">
  <img src="Screenshots/demo.gif" width="320"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17+-blue" />
  <img src="https://img.shields.io/badge/Swift-5-orange" />
  <img src="https://img.shields.io/badge/Architecture-MVVM-green" />
  <img src="https://img.shields.io/badge/UI-UIKit-lightgrey" />
  <img src="https://img.shields.io/badge/Networking-URLSession-yellow" />
</p>

<p align="center">
  A clean, scalable iOS app that showcases GitHub repositories with smooth UX, pagination, caching, and modern architecture.
</p>

---

## 🚀 Overview

**SquareReposApp** is a production-ready iOS application built using **UIKit + MVVM architecture**.
It demonstrates best practices in networking, state management, UI design, and performance optimization.

The app fetches repositories from GitHub and presents them with a polished user experience, including loading states, pagination, caching, and error handling.

---

## ✨ Features

* 🔍 Fetch GitHub repositories via API
* 📄 Infinite scrolling (pagination)
* ⚡ In-memory caching for fast reloads
* 🔄 Pull-to-refresh support
* ❌ Robust error handling with retry
* 🧊 Skeleton loading (shimmer effect)
* 🌙 Full Dark Mode support (system adaptive UI)
* 🎨 Smooth animations & modern card UI
* ⭐ Displays star count & language badge
* 🖼 Repository owner avatar loading
* 🌐 Open repository in in-app browser (SFSafariViewController)

---

## 🧱 Architecture

This project follows **MVVM (Model-View-ViewModel)** with clean separation of concerns:

* **Model** → Data structures (`Repo`, `Owner`)
* **View** → UI layer (`UITableView`, custom cells)
* **ViewModel** → Business logic, pagination, state handling

### 🔄 State Management

Handled via a `ViewState` enum:

* `loading`
* `loaded`
* `empty`
* `error`
* `paginationLoading`

---

## 📂 Project Structure

```id="p2b3m9"
SquareRepos
│
├── App
│   ├── AppDelegate.swift
│
├── Core
│   ├── Network
│   │   ├── APIService.swift
│   │   ├── APIServiceProtocol.swift
│   │
│   ├── Error
│   │   ├── AppError.swift
│
├── Features
│   └── RepoList
│       ├── Model
│       │   ├── Repo.swift
│       │
│       ├── ViewModel
│       │   ├── RepoListViewModel.swift
│       │   ├── ViewState.swift
│       │
│       ├── View
│       │   ├── RepoListViewController.swift
│       │   ├── RepoCell.swift
│       │   ├── LoadingCell.swift
│       │   ├── InitialLoaderView.swift
│       │
│       ├── Service (optional separation)
│           ├── ImageLoader.swift
│
├── Resources
│   ├── Screenshots
│   ├── Assets.xcassets
│   ├── LaunchScreen.storyboard
│   ├── Info.plist
│
│
└── Tests
    ├── UnitTests
    │   ├── APIServiceTests.swift
    │   ├── RepoListViewModelTests.swift
    │   ├── MockAPIService.swift
    │
    ├── UITests
        ├── SquareReposDemo2UITests.swift

```

---

## 🛠 Tech Stack

* Swift
* UIKit
* MVVM Architecture
* URLSession
* Auto Layout
* NSCache (Image + API caching)
* XCTest (Unit Testing)
* Git & GitHub

---

## 📸 Screenshots

<p align="center">
  <img src="Screenshots/lightThemHome.png" width="250"/>
  <img src="Screenshots/lightThemDetail.png" width="250"/>
</p>

---

## 🌙 Light & Dark Mode

<p align="center">
  <img src="Screenshots/darkthemHome.png" width="250"/>
  <img src="Screenshots/darkthemDetail.png" width="250"/>
</p>

---

## ⚙️ Setup & Installation

1. Clone the repository:

```id="y6bt0k"
git clone git@github.com:deepakdashwipro/SquareReposApp.git
```

2. Open in Xcode:

```id="9z2lqf"
SquareReposApp.xcodeproj
```

3. Run on simulator or device 🚀

---

## 🧪 Testing

Includes:

* ✅ Unit Tests for ViewModel
* ✅ Mock API testing

Run tests:

```id="k0m3xv"
Cmd + U
```

---

## 📌 Key Highlights

* Clean and scalable architecture
* Production-level error handling
* Smooth pagination without third-party libraries
* Efficient caching strategy
* Polished UI/UX with animations

---

## 🔮 Future Enhancements

* 🔎 Repository search
* 💾 Offline persistence (CoreData)
* 🔔 Favorites / bookmarking
* ⚡ SwiftUI version

---

## 👨‍💻 Author

**Deepak Kumar Dash**

---

## ⭐️ Support

If you found this project useful, consider giving it a ⭐️ on GitHub!

---
