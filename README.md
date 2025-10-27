# Personal Finance Tracker

A beautiful, modern web application for personal finance management built with Flutter. Track your income, expenses, and transactions with an elegant dark-themed interface.

## ✨ Features

- 💰 **Transaction Management** - Add, view, and delete transactions
- 📊 **Real-time Balance** - Automatic calculation of total balance, income, and expenses
- 🎨 **Beautiful UI** - Dark theme with gradient backgrounds and glass-morphic cards
- 📱 **Money Spent/Received** - Easy transaction type selection
- 🔔 **Notifications** - Toast notifications for actions
- 🎯 **Interactive** - Tap cards for details, long-press to delete

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/finance_tracker.git
cd finance_tracker
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run -d chrome
```

## 📸 Screenshots

The app features:

- Dark gradient backgrounds (black tones)
- Glass-morphic card design
- Real-time balance tracking
- Animated UI elements
- Interactive transaction lists

## 🛠️ Tech Stack

- **Flutter** - UI Framework
- **Riverpod** - State Management
- **Material Design 3** - UI Components

## 📝 Usage

### Adding Transactions

1. Click the "Add Transaction" button
2. Select "Money Spent" or "Money Received"
3. Enter title and amount
4. Click "Add Transaction"

### Viewing Balance

- Total balance is displayed at the top
- Tap the balance card for detailed breakdown
- Income and expenses are shown with separate cards

### Managing Transactions

- Long-press any transaction to delete it
- Confirm deletion in the dialog
- View transaction history in the list

## 🎨 Design Features

- **Dark Theme** - Professional black and dark gray color scheme
- **Glass Morphism** - Translucent cards with blur effects
- **Gradient Backgrounds** - Subtle gradient overlays
- **Color Accents** - Green for income, Red for expenses, Purple for add button
- **Responsive** - Works perfectly on desktop browsers

## 📦 Project Structure

```
finance_tracker/
├── lib/
│   └── main.dart          # Main application code
├── web/
│   ├── index.html         # Web entry point
│   ├── manifest.json      # PWA manifest
│   └── icons/             # App icons
├── pubspec.yaml           # Dependencies
└── README.md              # This file
```

## 🚢 Deployment

This is a web-only Flutter application. To build for production:

```bash
flutter build web
```

The built files will be in the `build/web/` directory.

## 👤 Author

**Majid Aliyev**

## 📄 License

This project is private and not licensed for public use.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI inspiration
- Different design inspiration
