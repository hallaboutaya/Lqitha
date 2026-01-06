# 💻 Developer Guide

## ⚙️ Environment Setup

### Prerequisites
*   **Flutter**: 3.x+
*   **Python**: 3.8+
*   **Supabase Account** (For remote DB)

### 1. Setting up the Backend
1.  Navigate to `flask_backend/`.
2.  Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```
3.  Configure Environment:
    *   Copy `.env.example` to `.env`.
    *   Fill in your Supabase credentials.
4.  Run tests to ensure system integrity:
    ```bash
    pytest tests/test_unit.py
    ```
5.  Start the server:
    ```bash
    python run.py
    ```

### 2. Setting up the Frontend
1.  Open `lib/config/api_config.dart`.
2.  Set `USE_API = true` to use your Flask server, or `false` to use local SQLite.
3.  Run the app:
    ```bash
    flutter run
    ```

---

## 🧪 Testing

### Backend Tests
We use **Pytest**.
*   **Unit Tests**: Located in `flask_backend/tests/`. Run with `pytest`.
*   **Verification**: Run `python verify_tests.py` for a quick pass/fail check.

### Frontend Tests
*   Run `flutter test` to execute widget/unit tests.

---

## 🐛 Debugging Guide

### "Connection Refused" (Frontend)
*   **Cause**: App cannot hit `localhost:5000`.
*   **Fix**:
    *   **Android Emulator**: Use `10.0.2.2:5000` instead of `localhost`.
    *   **Physical Device**: Use your PC's LAN IP (e.g., `192.168.1.X:5000`).
    *   Update `API_BASE_URL` in `lib/config/api_config.dart`.

### "Token Expired" / 401 Error
*   **Cause**: JWT is old.
*   **Fix**: Log out and Log in again.

### "Database Error"
*   **Cause**: Supabase credentials invalid or table missing.
*   **Fix**: Check `.env` and Supabase dashboard. Ensure tables (`users`, `found_posts`, etc.) exist.

---

## 🤝 Contribution Workflow

1.  **Branching**: Create a feature branch (`feat/login-ui`).
2.  **Code**: Implement changes.
3.  **Test**: Verified with `pytest` (backend) or manual run (frontend).
4.  **Merge**: Submit Pull Request.
