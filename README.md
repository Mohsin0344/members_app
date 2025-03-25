# Flutter Absence Management App

A Flutter application that manages absences and members, featuring state management with `flutter_bloc`, API calls using `Dio`, and test cases with `mockito`. The app supports filtering, pagination, and exporting absences as an ICS file.

##  Detail Demo of Flutter App: https://drive.google.com/file/d/1JGvs0SN7hRkOLtwXXUw7yPDHeb_axZNy/view?usp=sharing

## 📥 Installation Guide

### Prerequisites
- Flutter SDK installed ([Download Flutter](https://flutter.dev/docs/get-started/install))
- Dart installed
- Code editor (e.g., VS Code, Android Studio)

### Steps
1. Clone this repository:
   ```sh
   git clone https://github.com/Mohsin0344/members_app.git
   cd members_app
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the application:
   ```sh
   flutter run
   ```
4. To run tests:
   ```sh
   flutter test
   ```

---

## 🚀 Features

1. **Get all members**
2. **Get absent members** with their details
3. **Pagination** for member lists
4. **Filtering absences** by type and date
5. **Export absence list** as an ICS file
6. **See total absences** at a glance
7. **HTTP calls** handled using `Dio`
8. **State management** using `flutter_bloc`
9. **Unit and widget tests** using:
    - `mockito`
    - `bloc_test`
    - `build_runner`
    - `flutter_test`

## 📂 Project Structure

```
- api
  - api_client.dart
  - api_config.dart
  - api_methods.dart
  - api_routes.dart

- bloc_provider
  - bloc_providers.dart

- data
  - absence_ical_service.dart

- view_models
  - app_states.dart
  - view_model_exception_handler.dart
  - absence
    - absences_view_model.dart
    - absences_ical_view_model.dart
  - members
    - absent_members_view_model.dart
    - members_view_model.dart

- views
  - screens/
  - widgets/
```

## 🛠 Technologies Used
- **Flutter** (Dart)
- **flutter_bloc** for state management
- **Dio** for API calls
- **bloc_test, mockito, build_runner** for testing

---

