from flask import Blueprint, jsonify, request
from functools import wraps
from app import supabase
from app.utils.security import token_required
from app.routes.rewards import award_points
from app.utils.fcm import send_push_notification

admin_bp = Blueprint('admin', __name__)

def admin_required(f):
    @wraps(f)
    def decorated(current_user_id, *args, **kwargs):
        response = supabase.table('users').select('role').eq('id', current_user_id).execute()
        if not response.data or response.data[0].get('role') != 'admin':
            return jsonify({'success': False, 'error': 'Admin privileges required'}), 403
        return f(current_user_id, *args, **kwargs)
    return decorated

@admin_bp.route('/statistics', methods=['GET'])
@token_required
@admin_required
def get_statistics(current_user_id):
    try:
        # Aggregations using count (exact)
        found_stats = supabase.table('found_posts').select('id', count='exact').execute()
        lost_stats = supabase.table('lost_posts').select('id', count='exact').execute()
        
        pending_found = supabase.table('found_posts').select('id', count='exact').eq('status', 'pending').execute()
        pending_lost = supabase.table('lost_posts').select('id', count='exact').eq('status', 'pending').execute()
        
        approved_found = supabase.table('found_posts').select('id', count='exact').eq('status', 'approved').execute()
        approved_lost = supabase.table('lost_posts').select('id', count='exact').eq('status', 'approved').execute()
        
        users_count = supabase.table('users').select('id', count='exact').execute()
        
        stats = {
            'totalPosts': (found_stats.count or 0) + (lost_stats.count or 0),
            'pendingPosts': (pending_found.count or 0) + (pending_lost.count or 0),
            'approvedToday': (approved_found.count or 0) + (approved_lost.count or 0), # Note: this is total approved, not just today
            'activeUsers': users_count.count or 0
        }
        return jsonify({'success': True, 'statistics': stats}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@admin_bp.route('/status/found/<post_id>', methods=['PUT']) # Changed URL structure to be more RESTful under /admin
@token_required
@admin_required
def update_found_status(current_user_id, post_id):
    try:
        data = request.get_json()
        new_status = data.get('status')
        if not new_status: return jsonify({'success': False, 'error': 'Status required'}), 400
        
        # Get post to find owner
        post_response = supabase.table('found_posts').select('user_id').eq('id', post_id).execute()
        if not post_response.data:
            return jsonify({'success': False, 'error': 'Post not found'}), 404
        
        post_owner_id = post_response.data[0]['user_id']
        
        # Update status
        response = supabase.table('found_posts').update({'status': new_status}).eq('id', post_id).execute()
        
        # Award/deduct points based on status
        if new_status == 'approved':
            award_points(post_owner_id, 10, 'post_approved', 'Your found post was approved', post_id, 'found')
            send_push_notification(post_owner_id, "Post Approved! ✅", "Your found post has been approved and is now visible.")
        elif new_status == 'rejected':
            award_points(post_owner_id, -5, 'post_rejected', 'Your found post was rejected', post_id, 'found')
            send_push_notification(post_owner_id, "Post Rejected ❌", "Your found post was rejected by the admin.")
        
        return jsonify({'success': True, 'post': response.data[0]}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@admin_bp.route('/status/lost/<post_id>', methods=['PUT'])
@token_required
@admin_required
def update_lost_status(current_user_id, post_id):
    try:
        data = request.get_json()
        new_status = data.get('status')
        if not new_status: return jsonify({'success': False, 'error': 'Status required'}), 400
        
        # Get post to find owner
        post_response = supabase.table('lost_posts').select('user_id').eq('id', post_id).execute()
        if not post_response.data:
            return jsonify({'success': False, 'error': 'Post not found'}), 404
        
        post_owner_id = post_response.data[0]['user_id']
        
        # Update status
        response = supabase.table('lost_posts').update({'status': new_status}).eq('id', post_id).execute()
        
        # Award/deduct points based on status
        if new_status == 'approved':
            award_points(post_owner_id, 10, 'post_approved', 'Your lost post was approved', post_id, 'lost')
            send_push_notification(post_owner_id, "Post Approved! ✅", "Your lost post has been approved and is now visible.")
        elif new_status == 'rejected':
            award_points(post_owner_id, -5, 'post_rejected', 'Your lost post was rejected', post_id, 'lost')
            send_push_notification(post_owner_id, "Post Rejected ❌", "Your lost post was rejected by the admin.")
        
        return jsonify({'success': True, 'post': response.data[0]}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500
