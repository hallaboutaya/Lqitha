# Flask Backend for Lqitha

Flask REST API backend that connects to Supabase PostgreSQL database.

## 🚀 Quick Start

### 1. Install Dependencies
```bash
cd flask_backend
pip install -r requirements.txt
```

### 2. Configure Environment
The `.env` file is already configured with your Supabase credentials.

### 3. Run the Server
```bash
python app.py
```

Server will start at: `http://localhost:5000`

## 🧪 Testing the Connection

### Test 1: Health Check
```bash
curl http://localhost:5000/
```

Expected response:
```json
{
  "success": true,
  "message": "Lqitha Flask API is running!",
  "version": "1.0.0"
}
```

### Test 2: Database Connection
```bash
curl http://localhost:5000/test-db
```

This will test the Supabase connection by querying the users table.

### Test 3: Login (After Creating Tables)
```bash
curl -X POST http://localhost:5000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

## 📊 Current Endpoints

### Public Endpoints (No Auth Required)
- `GET /` - Health check
- `GET /test-db` - Test database connection
- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `GET /auth/check-email?email={email}` - Check if email exists

### Protected Endpoints (Require JWT Token)
- `GET /found-posts` - Get found posts (example)

## 🗄️ Next Steps

1. **Create Database Tables** in Supabase:
   - Go to Supabase Dashboard → SQL Editor
   - Run the SQL schema from `API_CONTRACT.md`

2. **Test the Connection**:
   - Run `python app.py`
   - Visit `http://localhost:5000/test-db`
   - Should see success message

3. **Implement Remaining Endpoints**:
   - Found posts (POST, PUT, DELETE)
   - Lost posts (all methods)
   - Notifications
   - Users
   - Admin

## 🔐 Authentication

Uses JWT (JSON Web Tokens):
1. User logs in → receives token
2. Client stores token
3. All subsequent requests include: `Authorization: Bearer {token}`

## 📝 Notes

- **Passwords**: Currently stored in plain text for development. In production, use bcrypt or similar!
- **CORS**: Enabled for all origins. In production, restrict to your Flutter app domain.
- **Debug Mode**: Currently enabled. Disable in production.

## 🐛 Troubleshooting

**Error: "Module not found"**
→ Run `pip install -r requirements.txt`

**Error: "Database connection failed"**
→ Check Supabase credentials in `.env`
→ Verify tables exist in Supabase

**Error: "Port 5000 already in use"**
→ Change port in `app.py`: `app.run(port=5001)`
