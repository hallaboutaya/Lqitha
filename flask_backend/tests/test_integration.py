"""
Integration tests for Lqitha Flask API

NOTE: These tests require:
1. A running Supabase database with tables created
2. Valid SUPABASE_URL and SUPABASE_KEY in .env
3. An admin user in the database (email: admin@lqitha.com)

Run with: pytest tests/test_integration.py -v
"""

import pytest
import json
import time
from app import create_app

@pytest.fixture(scope='module')
def app():
    """Create test app instance"""
    app = create_app()
    app.config.update({"TESTING": True})
    return app

@pytest.fixture(scope='module')
def client(app):
    """Create test client"""
    return app.test_client()

@pytest.fixture(scope='module')
def test_user_email():
    """Generate unique email for test user"""
    return f'test_user_{int(time.time())}@example.com'

@pytest.fixture(scope='module')
def registered_user(client, test_user_email):
    """Register a test user and return credentials"""
    response = client.post('/auth/register', 
        json={
            'username': 'Test User',
            'email': test_user_email,
            'password': 'testpass123',
            'phone_number': '+1234567890'
        }
    )
    data = json.loads(response.data)
    return {
        'email': test_user_email,
        'password': 'testpass123',
        'token': data.get('token'),
        'user_id': data.get('user', {}).get('id')
    }

# ==================== AUTHENTICATION TESTS ====================

def test_health_check(client):
    """Test health endpoint"""
    response = client.get('/health')
    assert response.status_code == 200

def test_register_new_user(client):
    """Test user registration"""
    unique_email = f'newuser_{int(time.time())}@example.com'
    
    response = client.post('/auth/register',
        json={
            'username': 'New User',
            'email': unique_email,
            'password': 'password123',
            'phone_number': '+9876543210'
        }
    )
    
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['success'] == True
    assert 'token' in data
    assert data['user']['username'] == 'New User'
    assert 'password' not in data['user']

def test_register_weak_password(client):
    """Test registration with weak password fails"""
    response = client.post('/auth/register',
        json={
            'username': 'Weak Pass User',
            'email': f'weak_{int(time.time())}@example.com',
            'password': 'short'  # Too short
        }
    )
    
    assert response.status_code == 400
    data = json.loads(response.data)
    assert data['success'] == False

def test_login_valid_credentials(client, registered_user):
    """Test login with valid credentials"""
    response = client.post('/auth/login',
        json={
            'email': registered_user['email'],
            'password': registered_user['password']
        }
    )
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['success'] == True
    assert 'token' in data

def test_login_invalid_password(client, registered_user):
    """Test login with wrong password fails"""
    response = client.post('/auth/login',
        json={
            'email': registered_user['email'],
            'password': 'wrongpassword'
        }
    )
    
    assert response.status_code == 401
    data = json.loads(response.data)
    assert data['success'] == False

# ==================== POSTS TESTS ====================

def test_unauthorized_access(client):
    """Test accessing protected endpoint without token fails"""
    response = client.get('/found-posts')
    assert response.status_code == 401

def test_create_found_post(client, registered_user):
    """Test creating a found post"""
    headers = {
        'Authorization': f'Bearer {registered_user["token"]}',
        'Content-Type': 'application/json'
    }
    
    response = client.post('/found-posts',
        headers=headers,
        json={
            'description': 'Found a black wallet',
            'location': 'Library',
            'category': 'Wallet'
        }
    )
    
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['success'] == True
    assert data['post']['status'] == 'pending'
    assert data['post']['description'] == 'Found a black wallet'

def test_create_lost_post(client, registered_user):
    """Test creating a lost post"""
    headers = {
        'Authorization': f'Bearer {registered_user["token"]}',
        'Content-Type': 'application/json'
    }
    
    response = client.post('/lost-posts',
        headers=headers,
        json={
            'description': 'Lost my keys',
            'location': 'Parking Lot',
            'category': 'Keys'
        }
    )
    
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['success'] == True

def test_get_found_posts(client, registered_user):
    """Test fetching found posts"""
    headers = {
        'Authorization': f'Bearer {registered_user["token"]}',
        'Content-Type': 'application/json'
    }
    
    response = client.get('/found-posts', headers=headers)
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['success'] == True
    assert isinstance(data['posts'], list)

# ==================== REWARDS TESTS ====================

def test_get_transactions(client, registered_user):
    """Test fetching user's transaction history"""
    headers = {
        'Authorization': f'Bearer {registered_user["token"]}',
        'Content-Type': 'application/json'
    }
    
    user_id = registered_user['user_id']
    response = client.get(f'/rewards/transactions?user_id={user_id}', headers=headers)
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['success'] == True
    assert isinstance(data['transactions'], list)

def test_get_leaderboard(client, registered_user):
    """Test fetching leaderboard"""
    headers = {
        'Authorization': f'Bearer {registered_user["token"]}',
        'Content-Type': 'application/json'
    }
    
    response = client.get('/rewards/leaderboard?limit=10', headers=headers)
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['success'] == True
    assert isinstance(data['leaderboard'], list)

# ==================== USER TESTS ====================

def test_get_user_profile(client, registered_user):
    """Test fetching user profile"""
    headers = {
        'Authorization': f'Bearer {registered_user["token"]}',
        'Content-Type': 'application/json'
    }
    
    user_id = registered_user['user_id']
    response = client.get(f'/users/{user_id}', headers=headers)
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['success'] == True
    assert data['user']['email'] == registered_user['email']
    assert 'password' not in data['user']  # Password should never be returned

# ==================== NOTIFICATIONS TESTS ====================

def test_get_notifications(client, registered_user):
    """Test fetching user notifications"""
    headers = {
        'Authorization': f'Bearer {registered_user["token"]}',
        'Content-Type': 'application/json'
    }
    
    user_id = registered_user['user_id']
    response = client.get(f'/notifications?user_id={user_id}', headers=headers)
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['success'] == True
    assert isinstance(data['notifications'], list)

# ==================== COMPLETE WORKFLOW TEST ====================

def test_post_creation_awards_points(client, registered_user):
    """Integration test: Verify post creation awards +5 points"""
    headers = {
        'Authorization': f'Bearer {registered_user["token"]}',
        'Content-Type': 'application/json'
    }
    user_id = registered_user['user_id']
    
    # Get initial points
    user_response = client.get(f'/users/{user_id}', headers=headers)
    initial_points = json.loads(user_response.data)['user']['points']
    
    # Create post
    post_response = client.post('/found-posts',
        headers=headers,
        json={
            'description': 'Integration test post',
            'location': 'Test Location',
            'category': 'Test'
        }
    )
    assert post_response.status_code == 201
    
    # Get updated points
    user_response = client.get(f'/users/{user_id}', headers=headers)
    new_points = json.loads(user_response.data)['user']['points']
    
    # Verify +5 points awarded
    assert new_points == initial_points + 5
    
    # Verify transaction exists
    trans_response = client.get(f'/rewards/transactions?user_id={user_id}&limit=1', headers=headers)
    transactions = json.loads(trans_response.data)['transactions']
    
    assert len(transactions) > 0
    latest_transaction = transactions[0]
    assert latest_transaction['transaction_type'] == 'post_created'
    assert latest_transaction['points'] == 5
