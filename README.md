# 📘 HabitForge – Habit & Study Tracker App

HabitForge is a Flutter-based mobile application designed to help users build consistent habits and manage their daily study routines.  
The app combines habit tracking, calendar views, reading progress, and a study timer into a clean and intuitive user interface with offline data storage.

---

## ✨ Features
- Create and manage daily habits
- Track habit completion over time
- Calendar-based habit overview
- Reading and study activity tracking
- Built-in study timer
- Light and Dark theme support
- Offline data persistence using a local database
- Drawer-based navigation for easy access

---

## 🛠 Tech Stack
- Flutter
- Dart
- Isar Database (local storage)
- Provider (state management)

---

## 💻 Development Environment
- IDE: Visual Studio Code  
- Emulator: Android Emulator (Android Studio)  
- Platform Tested: Android  

---

## 📂 Project Structure

lib/
├── database/
│   └── habit_database.dart
├── models/
│   ├── app_settings.dart
│   ├── app_settings.g.dart
│   ├── habit.dart
│   ├── habit.g.dart
│   ├── reading_log.dart
│   └── reading_log.g.dart
├── pages/
│   ├── calendar_page.dart
│   ├── home_page.dart
│   ├── reading_history_page.dart
│   └── study_timer_page.dart
├── themes/
│   ├── dark_mode.dart
│   ├── light_mode.dart
│   └── theme_provider.dart
├── utils/
│   └── habit_util.dart
├── widgets/
│   ├── habit_tile.dart
│   └── my_drawer.dart
└── main.dart

---

## ▶️ How to Run the Project
1. Clone the repository  
2. Navigate to the project directory  
3. Run `flutter pub get`  
4. Start an Android emulator  
5. Run `flutter run`  

---

## 📌 Project Information
- Project Type: Independent Flutter Project  
- Focus: Habit tracking and study productivity  
- Data Storage: Fully offline using a local database  

---

## ❤️ About This Project
This project was built to explore real-world Flutter application development by combining multiple features such as local data persistence, theming, navigation, and activity tracking.  
It helped strengthen practical understanding of state management, database integration, and clean UI design while focusing on user productivity and consistency.

---

## 🚀 Future Enhancements
- Habit progress analytics  
- Reminder and notification support  
- Cross-platform testing (iOS)  
