from flask import Blueprint, jsonify, request
from datetime import datetime
from app import supabase
from app.utils.security import token_required
from app.routes.rewards import award_points

posts_bp = Blueprint('posts', __name__)

# ==================== FOUND POSTS ====================

@posts_bp.route('/found-posts', methods=['GET', 'POST'])
@token_required
def found_posts(current_user_id):
    if request.method == 'GET':
        try:
            status = request.args.get('status')
            search = request.args.get('search')
            user_id = request.args.get('user_id')
            
            query = supabase.table('found_posts').select('*')
            
            if status: query = query.eq('status', status)
            if user_id: query = query.eq('user_id', user_id)
            if search:
                query = query.or_(f'description.ilike.%{search}%,location.ilike.%{search}%,category.ilike.%{search}%')
            
            query = query.order('created_at', desc=True)
            response = query.execute()
            
            return jsonify({'success': True, 'posts': response.data}), 200
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500
            
    elif request.method == 'POST':
        try:
            data = request.get_json()
            post_data = {
                'photo': data.get('photo'),
                'description': data.get('description'),
                'status': data.get('status', 'pending'),
                'location': data.get('location'),
                'category': data.get('category'),
                'user_id': current_user_id,
                'created_at': datetime.utcnow().isoformat()
            }
            response = supabase.table('found_posts').insert(post_data).execute()
            post = response.data[0]
            
            # Award points for creating post
            award_points(
                current_user_id, 
                5, 
                'post_created', 
                'Created a found post',
                post['id'],
                'found'
            )
            
            return jsonify({'success': True, 'post': post}), 201
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500

@posts_bp.route('/found-posts/<post_id>', methods=['GET', 'DELETE'])
@token_required
def get_found_post(current_user_id, post_id):
    if request.method == 'GET':
        try:
            response = supabase.table('found_posts').select('*').eq('id', post_id).execute()
            if not response.data:
                return jsonify({'success': False, 'error': 'Post not found'}), 404
            return jsonify({'success': True, 'post': response.data[0]}), 200
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500
    
    elif request.method == 'DELETE':
        try:
            # Check ownership (simple check for now)
            # You might want to allow admins to delete too
            response = supabase.table('found_posts').delete().eq('id', post_id).execute()
            return jsonify({'success': True, 'message': 'Post deleted'}), 200
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500

# ==================== LOST POSTS ====================

@posts_bp.route('/lost-posts', methods=['GET', 'POST'])
@token_required
def lost_posts(current_user_id):
    if request.method == 'GET':
        try:
            status = request.args.get('status')
            search = request.args.get('search')
            user_id = request.args.get('user_id')
            
            query = supabase.table('lost_posts').select('*')
            
            if status: query = query.eq('status', status)
            if user_id: query = query.eq('user_id', user_id)
            if search:
                query = query.or_(f'description.ilike.%{search}%,location.ilike.%{search}%,category.ilike.%{search}%')
            
            query = query.order('created_at', desc=True)
            response = query.execute()
            
            return jsonify({'success': True, 'posts': response.data}), 200
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500
            
    elif request.method == 'POST':
        try:
            data = request.get_json()
            post_data = {
                'photo': data.get('photo'),
                'description': data.get('description'),
                'status': data.get('status', 'pending'),
                'location': data.get('location'),
                'category': data.get('category'),
                'user_id': current_user_id,
                'created_at': datetime.utcnow().isoformat()
            }
            response = supabase.table('lost_posts').insert(post_data).execute()
            post = response.data[0]
            
            # Award points for creating post
            award_points(
                current_user_id, 
                5, 
                'post_created', 
                'Created a lost post',
                post['id'],
                'lost'
            )
            
            return jsonify({'success': True, 'post': post}), 201
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500

@posts_bp.route('/lost-posts/<post_id>', methods=['GET', 'DELETE'])
@token_required
def get_lost_post(current_user_id, post_id):
    if request.method == 'GET':
        try:
            response = supabase.table('lost_posts').select('*').eq('id', post_id).execute()
            if not response.data:
                return jsonify({'success': False, 'error': 'Post not found'}), 404
            return jsonify({'success': True, 'post': response.data[0]}), 200
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500
            
    elif request.method == 'DELETE':
        try:
            response = supabase.table('lost_posts').delete().eq('id', post_id).execute()
            return jsonify({'success': True, 'message': 'Post deleted'}), 200
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 500
