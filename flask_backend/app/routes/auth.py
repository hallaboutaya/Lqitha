from flask import Blueprint, request, jsonify
from datetime import datetime
from app import supabase
from app.utils.security import hash_password, check_password, generate_token
from app.utils.validators import validate_email, validate_password, validate_phone, ValidationError

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        
        if not email or not password:
            return jsonify({'success': False, 'error': 'Email and password required'}), 400
            
        # Get user
        response = supabase.table('users').select('*').eq('email', email).execute()
        
        if not response.data:
            return jsonify({'success': False, 'error': 'Invalid email or password'}), 401
            
        user = response.data[0]
        
        # Verify password (hashes)
        if not check_password(user['password'], password):
            return jsonify({'success': False, 'error': 'Invalid email or password'}), 401
            
        token = generate_token(user['id'])
        
        # Sanitize user object (remove password)
        user.pop('password', None)
        
        return jsonify({
            'success': True,
            'user': user,
            'token': token
        }), 200
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@auth_bp.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        
        email = data.get('email')
        password = data.get('password')
        username = data.get('username')
        phone = data.get('phone_number')
        
        # Validation
        try:
            validate_email(email)
            validate_password(password)
            validate_phone(phone)
        except ValidationError as e:
            return jsonify({'success': False, 'error': str(e)}), 400
            
        # Check existing
        existing = supabase.table('users').select('id').eq('email', email).execute()
        if existing.data:
            return jsonify({'success': False, 'error': 'Email already exists'}), 400
            
        # Hash password
        hashed_password = hash_password(password)
        
        user_data = {
            'username': username,
            'email': email,
            'password': hashed_password,
            'phone_number': phone,
            'role': 'user',
            'points': 0,
            'created_at': datetime.utcnow().isoformat(),
            'updated_at': datetime.utcnow().isoformat()
        }
        
        response = supabase.table('users').insert(user_data).execute()
        user = response.data[0]
        
        # Create welcome notification
        welcome_notif = {
            'user_id': user['id'],
            'title': 'Welcome to Lqitha! 🎉',
            'message': f"Hi {username}, thank you for joining us! Start helping others find their lost items or report something you've lost.",
            'type': 'system',
            'is_read': False,
            'created_at': datetime.utcnow().isoformat()
        }
        try:
            supabase.table('notifications').insert(welcome_notif).execute()
        except Exception as ne:
            print(f"Warning: Failed to create welcome notification: {ne}")
            
        token = generate_token(user['id'])
        user.pop('password', None)
        
        return jsonify({
            'success': True,
            'user': user,
            'token': token
        }), 201
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@auth_bp.route('/check-email', methods=['GET'])
def check_email():
    try:
        email = request.args.get('email')
        if not email:
            return jsonify({'success': False, 'error': 'Email required'}), 400
            
        response = supabase.table('users').select('id').eq('email', email).execute()
        return jsonify({'exists': len(response.data) > 0}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500
