# Fix Instructions for Supabase Client Error

## Problem
You're getting this error:
```
TypeError: Client.__init__() got an unexpected keyword argument 'proxy'
```

This is caused by a version incompatibility between `supabase-py` and `httpx`.

## Solution

### Option 1: Quick Fix (Recommended for Windows)

1. Navigate to the `flask_backend` directory:
   ```powershell
   cd flask_backend
   ```

2. Run the fix script:
   ```powershell
   .\fix_dependencies.bat
   ```

### Option 2: Manual Fix

1. Uninstall conflicting packages:
   ```powershell
   pip uninstall -y supabase gotrue httpx httpcore
   ```

2. Install compatible versions:
   ```powershell
   pip install -r requirements.txt
   ```

### Option 3: Use Virtual Environment (Best Practice)

1. Create a virtual environment:
   ```powershell
   python -m venv venv
   ```

2. Activate it:
   ```powershell
   .\venv\Scripts\Activate.ps1
   ```

3. Install dependencies:
   ```powershell
   pip install -r requirements.txt
   ```

4. Run the app:
   ```powershell
   python app.py
   ```

## What Changed

1. **Updated `requirements.txt`**: Changed `supabase==2.3.0` to `supabase>=2.8.0` to use a version with better compatibility
2. **Added error handling**: The app now handles missing Supabase credentials gracefully
3. **Added null checks**: All routes now check if Supabase is initialized before using it

## Verify It Works

After fixing, run:
```powershell
python app.py
```

You should see:
```
🚀 Flask app initialized
📡 Supabase URL: [your-url]
```

If you see a warning about missing credentials, create a `.env` file with:
```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
SECRET_KEY=your_secret_key
```

## Still Having Issues?

If the error persists:

1. Make sure you're using Python 3.8 or higher
2. Try upgrading pip: `python -m pip install --upgrade pip`
3. Clear pip cache: `pip cache purge`
4. Reinstall everything: `pip install --force-reinstall -r requirements.txt`

