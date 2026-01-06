import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def check_notifications():
    print("Checking notifications table...")
    response = supabase.table('notifications').select('*').limit(5).execute()
    print(f"Data found: {response.data}")
    
    if not response.data:
        print("Creating a test notification...")
        test_data = {
            "user_id": "2229bccf-2991-47e8-9dfb-8b3056c4807d",
            "title": "Welcome!",
            "message": "Your notifications are working.",
            "type": "info"
        }
        res = supabase.table('notifications').insert(test_data).execute()
        print(f"Created: {res.data}")

if __name__ == "__main__":
    check_notifications()
