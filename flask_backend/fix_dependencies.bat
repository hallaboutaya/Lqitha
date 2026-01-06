@echo off
echo ========================================
echo Fixing Flask Backend Dependencies
echo ========================================
echo.

echo Step 1: Uninstalling conflicting packages...
pip uninstall -y supabase gotrue httpx httpcore

echo.
echo Step 2: Installing compatible versions...
pip install -r requirements.txt

echo.
echo ========================================
echo Done! Try running: python app.py
echo ========================================
pause

