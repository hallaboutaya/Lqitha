# 🛠️ Lqitha Developer Guide

This guide contains everything you need to set up, develop, and test the Lqitha platform.

---

## 1. Local Environment Setup

### **Prerequisites**
- Flutter SDK (Latest Stable)
- Python 3.9+
- Supabase Account (for remote mode)
- Android Studio / VS Code with Flutter Extension

### **Frontend Setup**
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Configure `lib/config/api_config.dart`:
   - Set `USE_API = false` for local SQLite development.
   - Set `USE_API = true` for remote Flask/Supabase development.

### **Backend Setup (Flask)**
1. Navigate to `flask_backend/`.
2. Create a virtual environment: `python -m venv venv`.
3. Activate it: `source venv/bin/activate` (Mac/Linux) or `venv\Scripts\activate` (Windows).
4. Install requirements: `pip install -r requirements.txt`.
5. Create a `.env` file from `.env.example`:
   ```env
   SUPABASE_URL=your_url
   SUPABASE_KEY=your_key
   SECRET_KEY=your_jwt_secret
   ```
6. Start the server: `python run.py`.

---

## 2. Testing Strategy

### **Frontend Tests**
We use `flutter_test` and `bloc_test` for verifying our business logic.
```bash
# Run all Flutter tests
flutter test
```

### **Backend Tests**
We use `pytest` to verify API endpoints and database integrity.
```bash
cd flask_backend
pytest
```

---

## 3. Debugging & Troubleshooting

### **Common Issues**
- **Connection Refused**: Ensure the Flask server is running and your `API_BASE_URL` in `api_config.dart` matches your local IP (use `10.0.2.2:5000` for Android emulators).
- **SQLite Database Locked**: Ensure only one instance of the app/tool is accessing the `.db` file.
- **JWT Unauthorized**: Your session might have expired. Log out and log back in to refresh your token.

### **Debug Mode Features**
Lqitha includes a **Database Seeder** that automatically populates the local SQLite database with test users and items when you first launch the app in local mode.

---

## 4. Contributing Rules

1.  **Feature Branches**: Always create a new branch for your feature (`feature/your-feature`).
2.  **Linting**: Run `flutter analyze` before committing.
3.  **Documentation**: If you change an API endpoint, update the corresponding section in `ARCHITECTURE.md`.
4.  **Pull Requests**: Ensure all tests pass before submitting a PR.

---

## 5. Deployment

### **Backend**
The Flask app can be deployed to any WSGI-compliant server (Heroku, DigitalOcean, etc.). Ensure all environment variables from `.env` are set in your production environment.

### **Frontend**
- **Android**: `flutter build apk --release`
- **iOS**: `flutter build ios --release`
- **Web**: `flutter build web`

---

*Need help? Open an issue or contact the project maintainers.*
