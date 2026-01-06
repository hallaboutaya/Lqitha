# 🔧 Troubleshooting Guide

## Recent Activity Stuck on Loading

### Possible Causes & Solutions

#### 1. Backend Not Running
**Check**: Is the Flask backend running?
```bash
cd flask_backend
python run.py
```
You should see:
```
Starting Lqitha Flask API Server (Modular)
Server: http://localhost:5000
```

#### 2. Wrong API URL
**Check**: Is Flutter pointing to the right URL?

Open `lib/config/api_config.dart`:
```dart
static const String API_BASE_URL = 'http://localhost:5000';
```

**If running on Android Emulator**, change to:
```dart
static const String API_BASE_URL = 'http://10.0.2.2:5000';
```

**If running on Physical Device**, use your PC's IP:
```dart
static const String API_BASE_URL = 'http://192.168.1.X:5000';  // Replace X with your IP
```

#### 3. Check Console Logs
Look for these messages in Flutter console:
- `🔍 Loading transactions for user: ...` - Request started
- `✅ Loaded X transactions` - Success
- `❌ Error loading transactions: ...` - Error (read the message)

#### 4. Test Backend Manually
Open browser and go to: `http://localhost:5000/health`

You should see:
```json
{"status": "healthy", "version": "1.0.0"}
```

If you get an error, the backend isn't running properly.

---

## Image Picker Error (Web)

The error `Unsupported operation: _Namespace` is a known issue with `image_picker` on web.

### Solution:
This is in your existing code (`lib/core/utils/image_helper.dart`). The issue is web-specific and unrelated to the rewards system.

**Quick Fix**: Don't use image picker on web, or use a web-specific image picker package.

---

## No Transactions Showing

### Possible Reasons:

1. **No transactions exist yet**
   - Create a post to generate your first transaction (+5 points)
   - The transaction should appear immediately

2. **API Mode vs Local Mode**
   - Check `lib/config/api_config.dart`
   - If `USE_API = false`, transactions won't work (they're only in the API)
   - Set `USE_API = true` to use the backend

3. **Database Empty**
   - The `trust_point_transactions` table might be empty
   - Create a post to generate a transaction

---

## Testing the Rewards System

### Step-by-Step Test:

1. **Start Backend**:
   ```bash
   cd flask_backend
   python run.py
   ```

2. **Check API Config**:
   - Open `lib/config/api_config.dart`
   - Ensure `USE_API = true`
   - Ensure `API_BASE_URL` is correct for your device

3. **Run Flutter App**:
   ```bash
   flutter run
   ```

4. **Create a Post**:
   - Login to the app
   - Create a found/lost post
   - Check console for: `✅ Loaded 1 transactions`

5. **Check Profile**:
   - Go to Profile tab
   - "Recent Activity" should show: "Created a found post +5"
   - "Total Points" should show: 5 (or more)

---

## Debug Checklist

- [ ] Backend is running (`python run.py`)
- [ ] Backend health check works (`http://localhost:5000/health`)
- [ ] `USE_API = true` in `api_config.dart`
- [ ] Correct `API_BASE_URL` for your device
- [ ] User is logged in
- [ ] At least one post created
- [ ] Check Flutter console for error messages

---

## Still Not Working?

Run this test in your browser:

1. Login to the app
2. Open browser DevTools (F12)
3. Go to Network tab
4. Refresh profile page
5. Look for request to `/rewards/transactions`
6. Check the response

**If no request**: Flutter isn't calling the API
**If 401 error**: Authentication token issue
**If 500 error**: Backend error (check Flask console)
**If timeout**: Backend not reachable
