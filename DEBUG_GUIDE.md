# Quick Debug Guide

## 🐛 Common Errors and Fixes

### Error: "child == _child is not true"

This is a Flutter framework error that usually means:
1. **Data type mismatch** - UUID vs int
2. **Null data** - Missing required fields
3. **Widget rebuild issue** - State management problem

## 🔍 Check Console Output

Look for these in your Flutter console:
- `❌ Error parsing post:` - Shows which field is failing
- `📚 Stack trace:` - Shows where the error happened
- `⚠️ API returned null` - API didn't return data

## 🧪 Quick Tests

### 1. Check if API is returning data
Open browser console (F12) and check Network tab for:
- Request to `http://localhost:5000/found-posts`
- Response should have `{"success": true, "posts": [...]}`

### 2. Check Supabase data format
The API should return posts like:
```json
{
  "id": "b06e89ca-6477-4290-9315-2ab5d3ec2181",  // UUID string
  "description": "Found wallet",
  "status": "approved",
  "user_id": "b06e89ca-6477-4290-9315-2ab5d3ec2181"  // UUID string
}
```

### 3. Hot Restart Flutter
Press `R` in the Flutter terminal to hot restart (capital R, not lowercase r)

## 🔧 If Still Broken

Try switching back to local mode temporarily:
```dart
// lib/config/api_config.dart
static const bool USE_API = false;  // Back to SQLite
```

Then hot restart (`R`) to see if local mode works.

## 📊 Check Flask Console

Look at the Flask terminal for:
- `📡 GET: http://localhost:5000/found-posts` - Request received
- `📥 Response Status: 200` - Success
- Any error messages

## 🆘 Send Me

If still broken, send me:
1. **Flutter console output** (the terminal where you ran `flutter run`)
2. **Flask console output** (the terminal where Flask is running)
3. **Browser console** (F12 → Console tab)

This will help me pinpoint the exact issue!
