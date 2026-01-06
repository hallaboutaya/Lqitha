import os
from dotenv import load_dotenv
from supabase import create_client
from flask_bcrypt import Bcrypt

# Load env
load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Error: SUPABASE_URL or SUPABASE_KEY missing in .env")
    exit(1)

# Initialize
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
bcrypt = Bcrypt()

# Admin credentials
email = "admin@lqitha.com"
password = "admin123"
hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

def create_admin():
    print(f"🚀 Creating/Resetting admin user: {email}")
    
    # 1. DELETE existing user with this email
    try:
        supabase.table('users').delete().eq('email', email).execute()
        print(f"✅ Cleaned up old {email} if it existed")
    except Exception as e:
        print(f"⚠️ Warning during cleanup: {e}")

    # 2. INSERT new admin
    user_data = {
        "username": "System Admin",
        "email": email,
        "password": hashed_password,
        "role": "admin",
        "points": 1000
    }
    
    try:
        response = supabase.table('users').insert(user_data).execute()
        if response.data:
            print(f"🎉 SUCCESS! Admin user created.")
            print(f"📧 Login Email: {email}")
            print(f"🔑 Password: {password}")
        else:
            print("❌ Error: Failed to create user (no data returned)")
    except Exception as e:
        print(f"❌ Critical Error: {e}")

if __name__ == "__main__":
    create_admin()
