from flask import Blueprint, jsonify, request
from datetime import datetime
from app import supabase
from app.utils.security import token_required
from app.routes.rewards import award_points
from app.utils.fcm import send_push_notification

unlocks_bp = Blueprint('unlocks', __name__)

@unlocks_bp.route('', methods=['POST'])
@token_required
def create_unlock(current_user_id):
    """
    Unlock contact information for a post.
    Simulates payment by deducting points.
    """
    try:
        data = request.get_json()
        post_id = data.get('post_id')
        post_type = data.get('post_type') # 'found' or 'lost'
        
        if not post_id or not post_type:
            return jsonify({'success': False, 'error': 'post_id and post_type required'}), 400
            
        # Get post owner ID
        table = 'found_posts' if post_type == 'found' else 'lost_posts'
        post_response = supabase.table(table).select('user_id').eq('id', post_id).execute()
        if not post_response.data:
            return jsonify({'success': False, 'error': 'Post not found'}), 404
        
        post_owner_id = post_response.data[0]['user_id']

        # Check if already unlocked
        existing = supabase.table('contact_unlocks').select('id').eq('user_id', current_user_id).eq('post_id', post_id).execute()
        if existing.data:
            return jsonify({'success': True, 'message': 'Already unlocked', 'unlock': existing.data[0]}), 200
            
        # Create unlock record
        unlock_data = {
            'user_id': current_user_id,
            'post_id': post_id,
            'post_type': post_type,
            'created_at': datetime.utcnow().isoformat()
        }
        
        response = supabase.table('contact_unlocks').insert(unlock_data).execute()
        
        # Send notification to post owner
        if str(post_owner_id) != str(current_user_id):
            send_push_notification(
                post_owner_id, 
                "Contact Unlocked! 📩", 
                f"Someone just unlocked your contact information for your {post_type} item!"
            )

        return jsonify({
            'success': True,
            'unlock': response.data[0]
        }), 201
        
    except Exception as e:
        print(f"Error creating unlock: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@unlocks_bp.route('', methods=['GET'])
@token_required
def get_user_unlocks(current_user_id):
    """Get all contact unlocks for the current user"""
    try:
        response = supabase.table('contact_unlocks').select('*').eq('user_id', current_user_id).execute()
        
        return jsonify({
            'success': True,
            'unlocks': response.data
        }), 200
    except Exception as e:
        print(f"Error fetching unlocks: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500
