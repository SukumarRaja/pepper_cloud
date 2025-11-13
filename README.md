# TaskFlow - Flutter Task Management App

A beautiful and intuitive task management application built with Flutter, following clean architecture principles. Manage your daily tasks, set priorities, and stay organized with a clean and modern UI.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.13.0-blue" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Dart-3.1.0-blue" alt="Dart Version">
  <img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-blue" alt="Platforms">
  <img src="https://img.shields.io/badge/State%20Management-BLoC-blue" alt="State Management">
</p>

## ✨ Features

- 🎨 Clean and modern Material Design 3 UI
- 📱 Responsive layout that works on mobile and tablet
- 🔄 Real-time task management with BLoC state management
- 📅 Due date tracking with notifications
- 🔍 Search and filter tasks
- 📂 Task categories and priorities
- 🌓 Dark/Light theme support
- 📱 Offline first with local data persistence
- 🔄 Sync across devices (coming soon)

## 📱 Screenshots

<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
  <img src="screenshots/task_list_dark.png" alt="Task List Dark" width="200">
  <img src="screenshots/task_list_light.png" alt="Task List Light" width="200">
  <img src="screenshots/task_form.png" alt="Task Form" width="200">
  <img src="screenshots/task_details.png" alt="Task Details" width="200">
</div>

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.13.0 or higher)
- Dart SDK (3.1.0 or higher)
- Android Studio / VS Code with Flutter plugins
- For iOS: Xcode (macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pepper_cloud.git
   cd pepper_cloud
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🏗 Project Structure

```
lib/
├── core/
│   ├── network/     # App constants, strings, and enums
│   ├── theme/         # App theming and styling
│   └── utils/         # Utility functions and extensions
├── data/
│   ├── datasources/   # Local and remote data sources
│   ├── models/        # Data transfer objects and entities
│   └── repositories/  # Repository implementations
├── domain/
│   ├── entities/      # Business logic entities
│   ├── repositories/  # Abstract repository definitions
│   └── usecases/      # Application use cases
└── presentation/
    ├── bloc/         # BLoC state management
    ├── pages/        # App screens
    └── widgets/      # Reusable UI components
```

## 🛠 Built With

- [Flutter](https://flutter.dev/) - Beautiful native apps in record time
- [BLoC](https://bloclibrary.dev/) - Predictable state management
- [Dio](https://pub.dev/packages/dio) - Powerful HTTP client
- [Retrofit](https://pub.dev/packages/retrofit) - Type-safe HTTP client generator
- [SharedPreferences](https://pub.dev/packages/shared_preferences) - Local data persistence
- [Equatable](https://pub.dev/packages/equatable) - Simplify equality comparisons
- [Flutter Slidable](https://pub.dev/packages/flutter_slidable) - Swipe actions
- [Intl](https://pub.dev/packages/intl) - Internationalization and localization

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- BLoC Library for state management
- All the amazing package developers

## 📄 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.
