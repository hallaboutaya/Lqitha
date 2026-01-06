import jwt
from datetime import datetime, timedelta
from functools import wraps
from flask import request, jsonify, current_app
from app import bcrypt

def hash_password(password: str) -> str:
    """Hash a password using bcrypt"""
    return bcrypt.generate_password_hash(password).decode('utf-8')

def check_password(hashed_password: str, password: str) -> bool:
    """Verify a password against a hash. 
    Handles legacy plain text passwords gracefully if needed, 
    but primarily validates bcrypt hashes."""
    try:
        return bcrypt.check_password_hash(hashed_password, password)
    except ValueError:
        # Fallback for legacy plain text passwords (if strictly necessary)
        # return hashed_password == password
        return False

def generate_token(user_id: int) -> str:
    """Generate a JWT token for a user"""
    payload = {
        'user_id': user_id,
        'exp': datetime.utcnow() + timedelta(days=7)
    }
    return jwt.encode(payload, current_app.config['SECRET_KEY'], algorithm='HS256')

def token_required(f):
    """Decorator to protect routes with JWT"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(' ')[1]
            except IndexError:
                return jsonify({'success': False, 'error': 'Invalid token format'}), 401
        
        if not token:
            return jsonify({'success': False, 'error': 'Token is missing'}), 401
        
        try:
            data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=['HS256'])
            current_user_id = data['user_id']
        except jwt.ExpiredSignatureError:
            return jsonify({'success': False, 'error': 'Token has expired'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'success': False, 'error': 'Invalid token'}), 401
            
        return f(current_user_id, *args, **kwargs)
    
    return decorated
