from flask import Blueprint, jsonify, request
from datetime import datetime
from app import supabase
from app.utils.security import token_required
from app.utils.fcm import send_push_notification

rewards_bp = Blueprint('rewards', __name__)

def award_points(user_id, points, transaction_type, description, related_post_id=None, related_post_type=None):
    """
    Internal helper to award points and create transaction record.
    Returns the new total points for the user.
    """
    try:
        # Create transaction record
        transaction_data = {
            'user_id': user_id,
            'points': points,
            'transaction_type': transaction_type,
            'description': description,
            'related_post_id': related_post_id,
            'related_post_type': related_post_type,
            'created_at': datetime.utcnow().isoformat()
        }
        supabase.table('trust_point_transactions').insert(transaction_data).execute()
        
        # Create notification for point change
        title = "Trust Points!" if points > 0 else "Points Adjusted"
        notif_type = 'point_change'
        
        notification_data = {
            'user_id': user_id,
            'title': title,
            'message': f"{description} ({'+' if points > 0 else ''}{points} points)",
            'type': notif_type,
            'related_post_id': related_post_id,
            'is_read': False,
            'created_at': datetime.utcnow().isoformat()
        }
        try:
            supabase.table('notifications').insert(notification_data).execute()
            # Also send push notification
            send_push_notification(user_id, title, notification_data['message'])
        except Exception as ne:
            print(f"Warning: Failed to create notification for points: {ne}")
        
        # Update user's total points
        user_response = supabase.table('users').select('points').eq('id', user_id).execute()
        if user_response.data:
            current_points = user_response.data[0].get('points', 0)
            new_points = current_points + points
            supabase.table('users').update({'points': new_points}).eq('id', user_id).execute()
            return new_points
        return 0
    except Exception as e:
        print(f"Error awarding points: {e}")
        return None

@rewards_bp.route('/transactions', methods=['GET'])
@token_required
def get_transactions(current_user_id):
    """Get transaction history for a user"""
    try:
        user_id = request.args.get('user_id', current_user_id)
        limit = request.args.get('limit', 50)
        
        query = supabase.table('trust_point_transactions').select('*')
        query = query.eq('user_id', user_id)
        query = query.order('created_at', desc=True)
        query = query.limit(limit)
        
        response = query.execute()
        
        return jsonify({
            'success': True,
            'transactions': response.data
        }), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@rewards_bp.route('/leaderboard', methods=['GET'])
@token_required
def get_leaderboard(current_user_id):
    """Get top users by points"""
    try:
        limit = request.args.get('limit', 10)
        
        # Get users ordered by points
        response = supabase.table('users').select('id, username, photo, points').order('points', desc=True).limit(limit).execute()
        
        return jsonify({
            'success': True,
            'leaderboard': response.data
        }), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@rewards_bp.route('/award', methods=['POST'])
@token_required
def manual_award(current_user_id):
    """
    Manually award points (admin only or internal use).
    This is primarily for testing or admin actions.
    """
    try:
        # Check if admin (optional security check)
        user_response = supabase.table('users').select('role').eq('id', current_user_id).execute()
        if not user_response.data or user_response.data[0].get('role') != 'admin':
            return jsonify({'success': False, 'error': 'Admin privileges required'}), 403
        
        data = request.get_json()
        user_id = data.get('user_id')
        points = data.get('points')
        transaction_type = data.get('transaction_type', 'manual_award')
        description = data.get('description', 'Manual point adjustment')
        
        if not user_id or points is None:
            return jsonify({'success': False, 'error': 'user_id and points required'}), 400
        
        new_total = award_points(user_id, points, transaction_type, description)
        
        return jsonify({
            'success': True,
            'new_total': new_total
        }), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500
