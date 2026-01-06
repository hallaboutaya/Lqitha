# Supabase Setup Guide

## ✅ Changes Made

I've updated your app to work with Supabase! Here's what changed:

### 1. **Enabled API Mode**
- Changed `USE_API = true` in `lib/config/api_config.dart`
- App now uses Flask backend + Supabase instead of local SQLite

### 2. **Updated User Model**
- User IDs can now be either `int` (SQLite) or `String` (Supabase UUIDs)
- Handles both formats automatically

### 3. **Updated AuthService**
- Now supports both integer and UUID string user IDs
- Session persistence works with both formats

## 🔧 Setup Steps

### Step 1: Start Flask Backend

Make sure your Flask backend is running:

```powershell
cd flask_backend
python app.py
```

You should see:
```
🚀 Flask app initialized
📡 Supabase URL: [your-url]
```

### Step 2: Configure Flask Backend

Create a `.env` file in `flask_backend/` directory:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key
SECRET_KEY=your-secret-key-for-jwt
```

### Step 3: Update API Base URL (if needed)

If your Flask backend is running on a different URL, update `lib/config/api_config.dart`:

```dart
static const String API_BASE_URL = 'http://localhost:5000'; // or your Flask URL
```

**For Android Emulator:** Use `http://10.0.2.2:5000`  
**For Physical Device:** Use your computer's IP address (e.g., `http://192.168.1.100:5000`)

### Step 4: Test Login

Try logging in with one of your Supabase users:
- **Email:** `carol@example.com`
- **Password:** `password123`

Or:
- **Email:** `admin@lqitha.com`
- **Password:** `admin123`

## 🐛 Troubleshooting

### Issue: "Connection refused"
**Solution:** 
- Make sure Flask backend is running
- Check `API_BASE_URL` is correct
- For emulator, use `10.0.2.2:5000` instead of `localhost:5000`

### Issue: "401 Unauthorized"
**Solution:**
- Check Flask backend logs
- Verify Supabase credentials in `.env` file
- Make sure user exists in Supabase database

### Issue: Login button does nothing
**Solution:**
- Check debug console for logs (should see `🔵 Button pressed!`)
- Verify Flask backend is running and accessible
- Check network connectivity

## 📊 Debug Logs

The app now has extensive logging. When you try to login, you should see:

```
🔵 Button pressed!
✅ Form validated, calling AuthCubit.login
🔐 AuthCubit: Login called
🔍 UserRepository: validateCredentials called
📡 GET: http://localhost:5000/auth/login
✅ AuthCubit: Login successful
```

If you see errors, check the console output for details.

## 🔄 Switching Back to SQLite

If you want to use local SQLite again:

1. Change `USE_API = false` in `lib/config/api_config.dart`
2. Restart the app

## 📝 Notes

- **UUID Support:** The app now handles Supabase UUIDs automatically
- **Backward Compatible:** Still works with SQLite integer IDs
- **Session Persistence:** Works with both ID formats

