from flask import Blueprint, jsonify, request
from app import supabase
from app.utils.security import token_required, check_password, hash_password
from app.utils.validators import validate_password, ValidationError
from datetime import datetime

users_bp = Blueprint('users', __name__)

@users_bp.route('/<user_id>', methods=['GET'])
@token_required
def get_user(current_user_id, user_id):
    try:
        response = supabase.table('users').select('*').eq('id', user_id).execute()
        
        if not response.data:
            return jsonify({'success': False, 'error': 'User not found'}), 404
        
        user = response.data[0]
        user.pop('password', None) # Security: never send password
        
        return jsonify({
            'success': True,
            'user': user
        }), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@users_bp.route('/<user_id>', methods=['PUT'])
@token_required
def update_user(current_user_id, user_id):
    # Ensure user can only update their own profile
    if str(current_user_id) != str(user_id):
        return jsonify({'success': False, 'error': 'Unauthorized'}), 403
        
    try:
        data = request.get_json()
        updates = {}
        
        if 'username' in data:
            updates['username'] = data['username']
        if 'email' in data:
            updates['email'] = data['email']
        if 'phone_number' in data:
            updates['phone_number'] = data['phone_number']
        if 'photo' in data:
            updates['photo'] = data['photo']
            
        if not updates:
            return jsonify({'success': False, 'error': 'No updates provided'}), 400
            
        updates['updated_at'] = datetime.utcnow().isoformat()
            
        response = supabase.table('users').update(updates).eq('id', user_id).execute()
        
        if not response.data:
             return jsonify({'success': False, 'error': 'Failed to update user'}), 500

        user = response.data[0]
        user.pop('password', None)
        
        return jsonify({
            'success': True,
            'user': user
        }), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@users_bp.route('/change-password', methods=['POST'])
@token_required
def change_password(current_user_id):
    try:
        data = request.get_json()
        old_password = data.get('old_password')
        new_password = data.get('new_password')
        
        if not old_password or not new_password:
            return jsonify({'success': False, 'error': 'Old and new passwords required'}), 400
            
        # Get current user with password
        response = supabase.table('users').select('*').eq('id', current_user_id).execute()
        if not response.data:
            return jsonify({'success': False, 'error': 'User not found'}), 404
            
        user = response.data[0]
        
        # Verify old password
        if not check_password(user['password'], old_password):
            return jsonify({'success': False, 'error': 'Incorrect old password'}), 401
            
        # Validate new password strength
        try:
            validate_password(new_password)
        except ValidationError as ve:
            return jsonify({'success': False, 'error': str(ve)}), 400
            
        # Hash new password
        hashed_new_password = hash_password(new_password)
        
        # Update password
        supabase.table('users').update({
            'password': hashed_new_password,
            'updated_at': datetime.utcnow().isoformat()
        }).eq('id', current_user_id).execute()
        
        return jsonify({'success': True, 'message': 'Password changed successfully'}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@users_bp.route('/<user_id>/username', methods=['GET'])
@token_required
def get_username(current_user_id, user_id):
    try:
        response = supabase.table('users').select('username').eq('id', user_id).execute()
        
        if not response.data:
            return jsonify({'success': False, 'error': 'User not found'}), 404
            
        return jsonify({
            'success': True,
            'username': response.data[0]['username']
        }), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@users_bp.route('/fcm-token', methods=['POST'])
@token_required
def update_fcm_token(current_user_id):
    try:
        data = request.get_json()
        fcm_token = data.get('fcm_token')
        
        if not fcm_token:
            return jsonify({'success': False, 'error': 'FCM token required'}), 400
            
        supabase.table('users').update({
            'fcm_token': fcm_token,
            'updated_at': datetime.utcnow().isoformat()
        }).eq('id', current_user_id).execute()
        
        return jsonify({'success': True, 'message': 'FCM token updated successfully'}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500
