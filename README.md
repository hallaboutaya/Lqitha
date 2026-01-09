# 🦅 Lqitha - The Ultimate Lost & Found Platform

![Lqitha Banner](https://img.shields.io/badge/Status-Active%20Development-green?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Frontend-Flutter-blue?style=for-the-badge&logo=flutter)
![Flask](https://img.shields.io/badge/Backend-Flask-black?style=for-the-badge&logo=flask)
![Supabase](https://img.shields.io/badge/Database-Supabase-green?style=for-the-badge&logo=supabase)

**Lqitha** (Arabic for "Found it") is a robust, cross-platform ecosystem designed to solve the problem of lost items in university environments. It combines a sleek Flutter mobile experience with a scalable Flask backend and real-time data management via Supabase.

---

## ✨ Key Highlights

*   **🔄 Hybrid Data Layer**: Seamlessly switch between **Offline Mode** (SQLite) and **Cloud Mode** (Flask + Supabase).
*   **🤝 LQITOU Verification**: A specialized workflow for secure item claiming and owner verification.
*   **🛡️ Role-Based Access**: Dedicated portals for both everyday Users and Platform Administrators.
*   **🎮 Trust Ecosystem**: A gamified rewards system that encourages honest behavior and community participation.
*   **🌍 Truly Global**: Native support for English, Arabic (RTL), and French with localized UI.
*   **🔔 Intelligent Alerts**: Real-time push notifications for approvals, matches, and claims.

---

## 📸 Screenshots & Demo

> [!TIP]
> *Check out our [Walkthrough Guide](ARCHITECTURE.md#4-the-lqitou-flow-claiming-logic) for detailed UI flows.*

---

## 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| **Frontend** | Flutter, BLoC/Cubit, GetIt, Sqflite |
| **Backend** | Python Flask, JWT Auth, Blueprint Pattern |
| **Database** | Supabase (PostgreSQL), SQLite (Local) |
| **Security** | Bcrypt Hashing, JWT Tokens, Secure Envs |

---

## 🚀 Quick Start (60 Seconds)

### 1. Backend Launch
```bash
cd flask_backend
pip install -r requirements.txt
python run.py
```

### 2. Frontend Launch
```bash
flutter pub get
# Ensure your environment is set in lib/config/api_config.dart
flutter run
```

---

## 📖 Explore the Documentation

For a deep dive into how Lqitha works, check out our consolidated guides:

- 🏗️ **[ARCHITECTURE.md](ARCHITECTURE.md)**: Technical design, API contracts, and database schemas.
- 🛠️ **[DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)**: Setup, testing, debugging, and contribution rules.

---

## 👥 Meet the Team

Lqitha is a collaborative project built with ❤️ to make university life just a little bit easier.
