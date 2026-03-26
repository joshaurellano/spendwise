📱SpendWise - Expense Tracker App
A Flutter-based mobile expense tracking application that uses SQLite for persistent local storage and Provider for state management.

🚀 Features

Add, edit, and delete expenses
Categorize expenses (Food, Transport, Entertainment, Shopping, Others)
View all expenses with category filtering
Total spending summary
Data persists locally using SQLite


🛠️ Tech Stack
👉 Flutter
👉 SQLite

📦 Dependencies
yamldependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  sqflite: ^2.3.3+1
  path: ^1.9.0


```

---

## 🗂️ Project Structure
```
lib/
├── main.dart                         # App entry point, Provider setup
├── models/
│   └── expense.dart                  # Expense data model with toMap/fromMap
├── providers/
│   └── expense_provider.dart         # ChangeNotifier, manages expense state
├── services/
│   └── database_helper.dart          # SQLite singleton, CRUD operations
└── screens/
    ├── expenses_home_page.dart        # Home screen, recent expenses
    ├── all_expenses_page.dart         # All expenses with filter
    └── add_expense_page.dart          # Add and edit expense form

▶️ Getting Started
Prerequisites

Flutter SDK installed
Android device with USB Debugging enabled, or an Android emulator
ADB installed (comes with Android Studio)

Installation
bash# Clone the repository
git clone https://github.com/joshaurellano/spendwise.git

# Navigate into the project
cd spendwise

# Install dependencies
flutter pub get

# Run the app
flutter run

👨‍💻 Developed By
👉 Aurellano, Joshua Anthony,
👉 De Los Santos, Aron Ronel,
👉 Narvato, Dominicca
👉 Nobela, Marvin

BS-INFORMATION SYSTEM


