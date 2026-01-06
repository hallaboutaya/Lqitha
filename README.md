# 🦅 Lqitha - Lost & Found Platform

> **Status**: Active Development  
> **Backend**: Flask + Supabase (PostgreSQL)  
> **Frontend**: Flutter (Mobile/Web/Desktop)

**Lqitha** is a robust cross-platform application designed to bridge the gap between lost items and their owners in university environments. It features a complete "Lost & Found" workflow, including item posting, admin approval, smart matching, and the unique "Claim" (LQITOU) verification flow.

---

## 🚀 Key Features

*   **Dual Mode Architecture**: seamlessly switches between **Local Mode** (SQLite for offline dev) and **Remote Mode** (Flask API + PostgreSQL for prod).
*   **Secure Authentication**: Role-based access (User/Admin) with encrypted credentials.
*   **Admin Dashboard**: Dedicated portal for approving posts and viewing platform analytics.
*   **Smart Notifications**: Real-time alerts when items are claimed or approved.
*   **Multi-Language**: Native support for English, French, and Arabic (RTL layouts).
*   **"LQITOU" Flow**: A specialized verification workflow for claiming found items.

---

## 🛠️ Technology Stack

### **Frontend (Mobile)**
*   **Framework**: Flutter 3.x
*   **State Management**: `flutter_bloc` (Cubits)
*   **Architecture**: Clean Architecture (Repositories, Data Sources, UI)
*   **Local DB**: `sqflite`

### **Backend (API)**
*   **Framework**: Python Flask (Modular Plans)
*   **Database**: Supabase (PostgreSQL)
*   **Security**: JWT Authentication + Bcrypt Hashing
*   **Testing**: Pytest

---

## 🏃‍♂️ Quick Start

### 1. Backend Setup
The backend is located in `flask_backend/`.

```bash
cd flask_backend
pip install -r requirements.txt
# Create .env file based on .env.example
python run.py
```

### 2. Frontend Setup
The Flutter app is in the root directory.

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📚 Documentation Index

For detailed guides, please refer to the following documents:

*   **[ARCHITECTURE.md](ARCHITECTURE.md)**: Deep dive into the code structure, patterns (Repository, Factory), and the data layer implementation.
*   **[API_REFERENCE.md](API_REFERENCE.md)**: Complete specification of REST endpoints, request/response formats, and Database Schema.
*   **[DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)**: Setup guide, testing instructions, and how to contribute or debug.