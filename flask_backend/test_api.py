"""
Quick test script to verify Flask API endpoints
Run this while Flask server is running
"""

import requests
import json

BASE_URL = "http://localhost:5000"

def test_health_check():
    """Test 1: Health Check"""
    print("\n" + "="*50)
    print("TEST 1: Health Check")
    print("="*50)
    
    response = requests.get(f"{BASE_URL}/")
    print(f"Status Code: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    
    if response.status_code == 200:
        print("✅ Health check passed!")
    else:
        print("❌ Health check failed!")

def test_database_connection():
    """Test 2: Database Connection"""
    print("\n" + "="*50)
    print("TEST 2: Database Connection")
    print("="*50)
    
    response = requests.get(f"{BASE_URL}/test-db")
    print(f"Status Code: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    
    if response.status_code == 200 and response.json().get('success'):
        print("✅ Database connection successful!")
    else:
        print("❌ Database connection failed!")

def test_login():
    """Test 3: Login"""
    print("\n" + "="*50)
    print("TEST 3: Login")
    print("="*50)
    
    data = {
        "email": "test@example.com",
        "password": "password123"
    }
    
    response = requests.post(f"{BASE_URL}/auth/login", json=data)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    
    if response.status_code == 200 and response.json().get('success'):
        print("✅ Login successful!")
        token = response.json().get('token')
        print(f"\n🔑 JWT Token: {token[:50]}...")
        return token
    else:
        print("❌ Login failed!")
        return None

def test_protected_endpoint(token):
    """Test 4: Protected Endpoint (Found Posts)"""
    print("\n" + "="*50)
    print("TEST 4: Protected Endpoint (Found Posts)")
    print("="*50)
    
    headers = {
        "Authorization": f"Bearer {token}"
    }
    
    response = requests.get(f"{BASE_URL}/found-posts", headers=headers)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    
    if response.status_code == 200:
        print("✅ Protected endpoint works!")
    else:
        print("❌ Protected endpoint failed!")

if __name__ == "__main__":
    print("\n🧪 FLASK API TESTING SUITE")
    print("="*50)
    print("Make sure Flask server is running on http://localhost:5000")
    print("="*50)
    
    try:
        # Run tests
        test_health_check()
        test_database_connection()
        token = test_login()
        
        if token:
            test_protected_endpoint(token)
        
        print("\n" + "="*50)
        print("🎉 ALL TESTS COMPLETED!")
        print("="*50)
        
    except requests.exceptions.ConnectionError:
        print("\n❌ ERROR: Cannot connect to Flask server!")
        print("Make sure the server is running: python app.py")
    except Exception as e:
        print(f"\n❌ ERROR: {str(e)}")
