<div id="top">

<div align="center">

# FLUTTER TASK MANAGER (PPB FP QYQY)
### Organize Your Tasks, Boost Your Productivity Instantly

<p align="center">
<img src="https://img.shields.io/github/last-commit/qyqystilllearning/ppb_fp_qyqy?style=flat&logo=git&logoColor=white&color=0080ff" alt="last-commit">
<img src="https://img.shields.io/github/languages/count/qyqystilllearning/ppb_fp_qyqy?style=flat&color=0080ff" alt="repo-language-count">
</p>
<p align="center">
<em>Built using the following tools and technologies:</em>
</p>
<p align="center">
<img src="https://img.shields.io/badge/Flutter-02569B.svg?style=flat&logo=Flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2.svg?style=flat&logo=Dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Firebase-FFCA28.svg?style=flat&logo=Firebase&logoColor=black" alt="Firebase">
</p>

</div>

---

## Table of Contents

* [Overview](#overview)
* [Features](#features)
* [Technologies Used](#technologies-used)
* [Project Structure](#project-structure)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
  * [Usage](#usage)
* [How to Contribute](#how-to-contribute)
* [License](#license)

---

## Overview

*PPB FP QYQY* (Flutter Task Manager) is a cross-platform mobile application designed to help users efficiently manage and track their daily activities. Built with Flutter, this app provides a seamless and responsive user interface for organizing tasks into categories, handling user authentication, and maintaining personal profiles.

---

## Features

* **Secure Authentication:** Dedicated login and registration screens for secure access (`login_screen.dart`, `register_screen.dart`).
* **Task Management:** Allows users to add, edit, and manage their daily to-do lists dynamically (`add_edit_task_screen.dart`, `todo_task.dart`).
* **Categorization:** Group tasks into custom categories for structured organization (`categories_screen.dart`, `category_tasks_screen.dart`).
* **User Profile:** Manage account settings and personal details with a dedicated profile view (`profile_screen.dart`).
* **Cross-Platform Deployment:** Ready to run natively on Android, iOS, Web, Windows, macOS, and Linux from a single codebase.
* **Custom Theming:** Utilizes a unified application theme for a consistent user experience (`app_theme.dart`).

---

## Technologies Used

* **Frontend:** Flutter & Dart
* **Backend/Cloud Integration:** Firebase (`firebase.json`)
* **Local Storage/Database:** Custom database service integration (`database_service.dart`)

---

## Project Structure

The project follows a clean and modular architecture, primarily located within the `lib/` directory:

```text
lib/
├── models/         # Data models (e.g., todo_task.dart)
├── screens/        # UI Screens (auth, home, categories, profile)
├── services/       # Core business logic and database handlers (e.g., database_service.dart)
├── theme/          # Application themes and styling rules
└── widgets/        # Reusable UI components (e.g., task_tile.dart)
```

---

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing.

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest stable version recommended)
* Dart SDK
* Android Studio (for Android development) or Xcode (for iOS/macOS development)

### Installation

**1. Clone the repository:**
```bash
git clone https://github.com/qyqystilllearning/ppb_fp_qyqy.git
```

**2. Navigate to the project directory:**
```bash
cd ppb_fp_qyqy
```

**3. Install the dependencies:**
```bash
flutter pub get
```

### Usage

1. Open your terminal or IDE terminal in the project root.
2. Run the application on your connected emulator or physical device:

```bash
flutter run
```

**Example Workflow:**

* Launch the app and navigate to the Register screen to set up a new account.
* Log in and tap the "+" button to invoke the `add_edit_task_screen`.
* Assign a category to your task, save it, and view it populated in the `task_tile` widget on your Home screen.

---

## How to Contribute

We welcome contributions! If you have a suggestion that would make this project better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.

<div align="right">

[⬆ Back to Top](#top)

</div>