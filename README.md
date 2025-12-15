# 📖 Zawiyah - Complete Islamic Companion

Zawiyah: Your Digital Gateway to Spiritual Enlightenment
Immerse yourself in the divine words of the Quran, embrace daily duas, and track your Islamic journey with elegance. Experience worship reimagined through modern technology, designed to nurture faith and facilitate devotion with every interaction.

## ✨ Complete Features

### 📚 Quran Section
- Full Quran reading with translation
- Quran shortcuts for quick navigation
- Audio recitation support
- Verse bookmarks & highlights

### 🕌 Worship Tools
- **Asma ul Husna** (99 Names of Allah)
- **Manzil** & protective duas
- **Daily Duas** collection
- **Tasbih counter**

### 📅 Islamic Calendar
- Ramadan calendar with daily tracking
- Prayer time notifications
- Islamic event reminders

### 👤 User Experience
- **Multi-language** app interface
- **Brightness control** for reading
- **Font size adjustment**
- **Dark/Light theme** toggle
- **Daily Islamic reminders**

### 🔐 Account Management
- Secure Firebase login/signup
- User profile with progress
- Rate app & feedback system
- Logout with data preservation

### 🎨 UI Components
-Custom Arabic typography
-Responsive grid layouts
-Smooth page transitions
-Gradient backgrounds
-Icon-based navigation

### 🔧 Configuration
 Language Support
-Add languages in lib/l10n/ folder:
-English (default)
-Urdu
-Arabic
-Dutch
-Spanish
-Hindi
-Bangali
-Melayu

## 🛠️ Tech Stack
- **Frontend:** Flutter
- **Backend:** Firebase (Auth, Firestore, Storage)
- **State Management:** Provider
- **Local Database:** Hive/SQLite

### Firebase Setup
- Create Firebase project
- Enable Authentication & Firestore
- Download google-services.json to android/app/

### 📦 Main Dependencies
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.13.0
  provider: ^6.1.1
  shared_preferences: ^2.2.2

## 🚀 Quick Start 
1. **Clone & Install**
```bash
git clone https://github.com/areebax07/Zawiyah-Quran-App.git
cd zawiyah
flutter pub get


