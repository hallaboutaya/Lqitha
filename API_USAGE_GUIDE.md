# API Layer Usage Guide

## 🎯 Quick Start

Your Flutter app now supports **two modes**:
1. **Local Mode** (SQLite) - Default, works offline
2. **API Mode** (Flask + Supabase) - Requires backend server

## 🔄 Switching Between Modes

### Option 1: Local SQLite Mode (Default)
In `lib/config/api_config.dart`:
```dart
static const bool USE_API = false;
```

### Option 2: API Mode
In `lib/config/api_config.dart`:
```dart
static const bool USE_API = true;
static const String API_BASE_URL = 'http://localhost:5000'; // Your Flask API URL
```

**That's it!** No other code changes needed. Your Cubits and UI remain unchanged.

---

## 📁 What Was Added

### New Files Created

#### Configuration
- `lib/config/api_config.dart` - Feature flag and API settings

#### HTTP Client
- `lib/services/api_client.dart` - HTTP client with authentication

#### API Repositories
- `lib/data/repositories/api/api_found_repository.dart`
- `lib/data/repositories/api/api_lost_repository.dart`
- `lib/data/repositories/api/api_notification_repository.dart`
- `lib/data/repositories/api/api_user_repository.dart`
- `lib/data/repositories/api/api_admin_repository.dart`

#### Documentation
- `API_CONTRACT.md` - Complete API specification for your Flask teammate

### Modified Files
- `pubspec.yaml` - Added `http: ^1.2.0` package
- `lib/services/service_locator.dart` - Added repository switching logic

---

## 🚀 Testing the Implementation

### Step 1: Test Local Mode (Should Work Now)
```dart
// In lib/config/api_config.dart
static const bool USE_API = false;
```

Run your app - everything should work exactly as before.

### Step 2: Prepare for API Mode
1. Give `API_CONTRACT.md` to your Flask teammate
2. Wait for them to implement the endpoints
3. Get the Flask server URL (e.g., `http://192.168.1.100:5000`)

### Step 3: Switch to API Mode
```dart
// In lib/config/api_config.dart
static const bool USE_API = true;
static const String API_BASE_URL = 'http://192.168.1.100:5000'; // Your Flask URL
```

### Step 4: Test API Mode
1. Make sure Flask server is running
2. Run your Flutter app
3. Try logging in - this will test authentication
4. Create a post - this will test POST endpoints
5. View posts - this will test GET endpoints

---

## 🔐 How Authentication Works

### Local Mode
- Credentials checked against SQLite database
- No tokens needed

### API Mode
1. User logs in → `POST /auth/login`
2. Flask returns JWT token
3. Token stored in `ApiClient`
4. All subsequent requests include `Authorization: Bearer {token}` header
5. User logs out → token cleared

---

## 🐛 Troubleshooting

### Error: "Connection refused"
**Problem**: Can't reach Flask API  
**Solution**: 
- Check Flask server is running
- Verify `API_BASE_URL` is correct
- If using emulator, use `10.0.2.2:5000` instead of `localhost:5000`
- If using physical device, use computer's IP address

### Error: "401 Unauthorized"
**Problem**: Authentication failed  
**Solution**:
- Check email/password are correct
- Verify Flask `/auth/login` endpoint is working
- Check Flask is returning a `token` in the response

### Error: "ApiException (404): Resource not found"
**Problem**: Endpoint doesn't exist  
**Solution**:
- Verify Flask teammate implemented the endpoint
- Check endpoint URL matches `API_CONTRACT.md`
- Check Flask server logs for errors

### Error: "TimeoutException"
**Problem**: Request took too long  
**Solution**:
- Check Flask server is responding
- Increase timeout in `api_config.dart`:
  ```dart
  static const int REQUEST_TIMEOUT_SECONDS = 60; // Increase from 30
  ```

### App works locally but not with API
**Problem**: Data format mismatch  
**Solution**:
- Check Flask response format matches `API_CONTRACT.md`
- Verify JSON field names match (e.g., `created_at` not `createdAt`)
- Check Flask returns timestamps in ISO 8601 format

---

## 📊 Data Flow Comparison

### Local Mode
```
UI → Cubit → FoundRepository → SQLite → FoundPost model → Cubit → UI
```

### API Mode
```
UI → Cubit → ApiFoundRepository → ApiClient → Flask API → Supabase → 
     JSON response → FoundPost model → Cubit → UI
```

**Key Point**: Cubit doesn't know which repository it's using! Same interface, different implementation.

---

## 🔧 Advanced Configuration

### Custom Endpoints
If your Flask API uses different endpoint paths, update `lib/config/api_config.dart`:

```dart
static const String FOUND_POSTS = '/api/v1/found-posts'; // Custom path
```

### Custom Timeout
```dart
static const int REQUEST_TIMEOUT_SECONDS = 60; // 1 minute
```

### Multiple Environments
```dart
// Development
static const String API_BASE_URL = 'http://localhost:5000';

// Staging
// static const String API_BASE_URL = 'https://staging-api.lqitha.com';

// Production
// static const String API_BASE_URL = 'https://api.lqitha.com';
```

---

## 📝 For Your Flask Teammate

### What They Need
1. **API Contract**: `API_CONTRACT.md` (complete specification)
2. **Database Schema**: PostgreSQL tables defined in contract
3. **Response Format**: Must match exactly (JSON field names, data types)
4. **Authentication**: JWT tokens or session-based (their choice)

### What They'll Build
- Flask REST API with ~30 endpoints
- Supabase PostgreSQL database
- Authentication system
- Admin approval workflow
- LQITOU claim functionality

### Testing Together
1. They run Flask locally: `flask run --host=0.0.0.0 --port=5000`
2. You get their IP address
3. You update `API_BASE_URL` in `api_config.dart`
4. You test the app together

---

## ✅ Checklist for Demo/Submission

### Before Demo
- [ ] Test app in **local mode** (USE_API = false)
- [ ] Test app in **API mode** (USE_API = true) with Flask running
- [ ] Verify login works in both modes
- [ ] Verify posts display in both modes
- [ ] Verify notifications work in both modes

### For Professor
Show both modes:
1. **Local Mode**: "Here's the app working with local SQLite database"
2. **API Mode**: "Here's the same app using our Flask backend and Supabase"
3. **Code**: "We only changed one boolean flag - no UI or logic changes"

### Key Points to Mention
- ✅ Implements repository pattern with dependency injection
- ✅ Supports both local and remote data sources
- ✅ Zero changes to business logic (Cubits) or UI
- ✅ Easy to switch between modes
- ✅ Complete API documentation for backend team

---

## 🎓 Architecture Benefits

### Separation of Concerns
- **UI Layer**: Doesn't know about data source
- **Business Logic (Cubits)**: Doesn't know about data source
- **Data Layer**: Swappable implementations

### Testability
- Can mock repositories for testing
- Can test with local data without backend
- Can test API calls independently

### Flexibility
- Easy to add more data sources (e.g., Firebase)
- Easy to switch between modes
- Easy to maintain

---

## 📞 Need Help?

### Common Questions

**Q: Can I use both modes at the same time?**  
A: No, you must choose one. But you can switch anytime by changing `USE_API`.

**Q: Will my local data sync with the API?**  
A: No, they're completely separate. Local mode uses SQLite, API mode uses Supabase.

**Q: Do I need to change my Cubits?**  
A: No! That's the beauty of this design. Cubits work with both implementations.

**Q: What if Flask is down?**  
A: In API mode, the app won't work. Switch to local mode for offline functionality.

**Q: Can I deploy this to production?**  
A: Yes! Update `API_BASE_URL` to your production server and set `USE_API = true`.

---

## 🎉 Summary

You now have:
- ✅ Complete API layer implementation
- ✅ Feature flag to switch modes
- ✅ Zero changes to existing code
- ✅ Full documentation for Flask teammate
- ✅ Error handling and authentication
- ✅ Ready for demo and submission

**Next Steps**:
1. Test local mode (should work immediately)
2. Share `API_CONTRACT.md` with Flask teammate
3. Wait for Flask implementation
4. Test API mode together
5. Demo both modes to professor! 🎓
