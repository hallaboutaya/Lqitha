# Lqitha Project Structure

## ✅ Current Structure

```
c:\3rd Year\Mobilelabs\Lqitha-halaaaaa\
├── lib/                  ← Flutter app code
├── android/              ← Android config
├── ios/                  ← iOS config
├── pubspec.yaml          ← Flutter dependencies
├── API_CONTRACT.md       ← API specification
├── API_USAGE_GUIDE.md    ← How to use API
│
└── flask_backend/        ← Flask API backend
    ├── app.py            ← Flask server
    ├── .env              ← Supabase credentials
    ├── requirements.txt  ← Python dependencies
    ├── schema.sql        ← Database schema
    ├── README.md         ← Setup guide
    └── TESTING.md        ← Testing guide
```

## 🚀 Running Both Projects

### Terminal 1: Flutter App
```bash
cd "c:\3rd Year\Mobilelabs\Lqitha-halaaaaa"
flutter run
```

### Terminal 2: Flask Backend
```bash
cd "c:\3rd Year\Mobilelabs\Lqitha-halaaaaa\flask_backend"
pip install -r requirements.txt
python app.py
```

## 📍 Important Paths

- **Flutter Config**: `lib\config\api_config.dart`
- **Flask Backend**: `flask_backend\app.py`
- **API Docs**: `API_CONTRACT.md`

Everything is now in one project folder! 🎉
