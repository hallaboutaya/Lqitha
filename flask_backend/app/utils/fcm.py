import firebase_admin
from firebase_admin import credentials, messaging
import os
from app import supabase

# Path to the service account key file
# It should be in the root of the flask_backend folder
SERVICE_ACCOUNT_KEY = 'serviceAccountKey.json'

def init_fcm():
    """Initialize Firebase Admin SDK"""
    try:
        if not firebase_admin._apps:
            if os.path.exists(SERVICE_ACCOUNT_KEY):
                cred = credentials.Certificate(SERVICE_ACCOUNT_KEY)
                firebase_admin.initialize_app(cred)
                print("🔥 Firebase Admin SDK initialized successfully.")
            else:
                print(f"⚠️ Warning: {SERVICE_ACCOUNT_KEY} not found. FCM will not work.")
    except Exception as e:
        print(f"❌ Error initializing Firebase Admin SDK: {e}")

def send_push_notification(user_id, title, body, data=None):
    """
    Send a push notification to a specific user via their fcm_token.
    """
    if not firebase_admin._apps:
        print("⚠️ FCM not initialized. Skipping notification.")
        return False

    try:
        # Get user's FCM token from database
        response = supabase.table('users').select('fcm_token').eq('id', user_id).execute()
        
        if not response.data or not response.data[0].get('fcm_token'):
            print(f"ℹ️ No FCM token found for user {user_id}. Skipping.")
            return False

        fcm_token = response.data[0]['fcm_token']

        # Construct the message
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            data=data or {},
            token=fcm_token,
        )

        # Send the message
        response = messaging.send(message)
        print(f"✅ Successfully sent message to user {user_id}: {response}")
        return True

    except Exception as e:
        print(f"❌ Error sending FCM message to user {user_id}: {e}")
        return False
