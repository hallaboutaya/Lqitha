from flask import Blueprint, jsonify, request
from datetime import datetime
from app import supabase
from app.utils.security import token_required

notifications_bp = Blueprint('notifications', __name__)

@notifications_bp.route('/', methods=['GET', 'POST'])
@token_required
def notifications(current_user_id):
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            unread = request.args.get('unread')
            notif_type = request.args.get('type')
            
            query = supabase.table('notifications').select('*')
            
            if user_id: query = query.eq('user_id', user_id)
            if unread == 'true': query = query.eq('is_read', False)
            if notif_type: query = query.eq('type', notif_type)
            
            query = query.order('created_at', desc=True)
            response = query.execute()
            
            return jsonify({'success': True, 'notifications': response.data}), 200
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500
            
    elif request.method == 'POST':
        try:
            data = request.get_json()
            notification_data = {
                'title': data.get('title'),
                'message': data.get('message'),
                'user_id': data.get('user_id'),
                'type': data.get('type'),
                'is_read': False,
                'related_post_id': data.get('related_post_id'),
                'created_at': datetime.utcnow().isoformat()
            }
            response = supabase.table('notifications').insert(notification_data).execute()
            return jsonify({'success': True, 'notification': response.data[0]}), 201
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500

@notifications_bp.route('/unread-count', methods=['GET'])
@token_required
def get_unread_count(current_user_id):
    try:
        user_id = request.args.get('user_id') or current_user_id
        response = supabase.table('notifications').select('id', count='exact').eq('user_id', user_id).eq('is_read', False).execute()
        return jsonify({'success': True, 'count': response.count}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@notifications_bp.route('/mark-all-read', methods=['PUT'])
@token_required
def mark_all_read(current_user_id):
    try:
        response = supabase.table('notifications').update({'is_read': True}).eq('user_id', current_user_id).eq('is_read', False).execute()
        return jsonify({'success': True, 'updated_count': len(response.data)}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@notifications_bp.route('/<notification_id>/read', methods=['PUT'])
@token_required
def mark_notification_read(current_user_id, notification_id):
    try:
        response = supabase.table('notifications').update({'is_read': True}).eq('id', notification_id).execute()
        if not response.data:
            return jsonify({'success': False, 'error': 'Notification not found'}), 404
        return jsonify({'success': True, 'notification': response.data[0]}), 200
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500
