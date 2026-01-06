import 'package:sqflite/sqflite.dart';
import '../../models/lost_post.dart';
import '../lost_repository.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';

/// API implementation of LostRepository.
/// 
/// Makes HTTP calls to Flask API instead of querying local SQLite database.
/// Extends LostRepository for seamless switching.
class ApiLostRepository extends LostRepository {
  final ApiClient _apiClient = ApiClient();
  
  // Override _db getter to prevent SQLite access (not used in API mode)
  @override
  Future<Database> get _db async => throw UnimplementedError('Use API methods instead of _db');

  /// Fetch all approved lost posts from the API.
  @override
  Future<List<LostPost>> getApprovedPosts() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.LOST_POSTS,
        queryParams: {'status': 'approved'},
      );

      final List<dynamic>? postsJson = response['posts'];
      if (postsJson == null) {
        print('⚠️ API returned null posts, returning empty list');
        return [];
      }
      
      return postsJson.map((json) {
        try {
          return LostPost.fromMap(json);
        } catch (e) {
          print('❌ Error parsing post: $e');
          print('   Post data: $json');
          return null;
        }
      }).whereType<LostPost>().toList();
    } catch (e, stackTrace) {
      print('❌ Error fetching approved lost posts from API: $e');
      print('📚 Stack trace: $stackTrace');
      // Return empty list instead of rethrowing to prevent UI crash
      return [];
    }
  }

  /// Search for approved lost posts matching the query.
  Future<List<LostPost>> searchPosts(String query) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.LOST_POSTS,
        queryParams: {
          'status': 'approved',
          'search': query,
        },
      );

      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => LostPost.fromMap(json)).toList();
    } catch (e) {
      print('Error searching lost posts from API: $e');
      return [];
    }
  }

  /// Fetch all lost posts for a specific user from API.
  @override
  Future<List<LostPost>> getPostsByUserId(dynamic userId, {String? status}) async {
    try {
      Map<String, String> queryParams = {'user_id': userId.toString()};
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      final response = await _apiClient.get(
        ApiConfig.LOST_POSTS,
        queryParams: queryParams,
      );

      final List<dynamic>? postsJson = response['posts'];
      if (postsJson == null) {
        return [];
      }
      
      return postsJson.map((json) {
        try {
          return LostPost.fromMap(json);
        } catch (e) {
          print('❌ Error parsing post: $e');
          return null;
        }
      }).whereType<LostPost>().toList();
    } catch (e, stackTrace) {
      print('❌ Error fetching posts by user id from API: $e');
      print('📚 Stack trace: $stackTrace');
      return [];
    }
  }

  /// Insert a new lost post via API.
  /// 
  /// Returns the id of the newly created post.
  @override
  Future<dynamic> insertPost(LostPost post) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.LOST_POSTS,
        body: post.toMap(),
      );

      final createdPost = response['post'];
      return createdPost['id'];
    } catch (e) {
      print('Error inserting lost post via API: $e');
      rethrow;
    }
  }

  /// Update an existing lost post via API.
  /// 
  /// Returns the number of rows affected (1 on success).
  Future<int> updatePost(LostPost post) async {
    try {
      if (post.id == null) {
        throw Exception('Cannot update post without id');
      }

      await _apiClient.put(
        '${ApiConfig.LOST_POSTS}/${post.id}',
        body: {
          'photo': post.photo,
          'description': post.description,
          'location': post.location,
          'category': post.category,
        },
      );

      return 1; // Success
    } catch (e) {
      print('Error updating lost post via API: $e');
      rethrow;
    }
  }

  /// Get a single lost post by id from API.
  @override
  Future<LostPost?> getPostById(dynamic id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.LOST_POSTS}/$id',
      );

      final postJson = response['post'];
      return LostPost.fromMap(postJson);
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        return null;
      }
      print('Error fetching lost post by id from API: $e');
      rethrow;
    }
  }

  /// Get all lost posts for a specific user from API.
  @override
  Future<List<LostPost>> getPostsByUser(dynamic userId) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.LOST_POSTS,
        queryParams: {'user_id': userId.toString()},
      );

      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => LostPost.fromMap(json)).toList();
    } catch (e) {
      print('Error fetching user lost posts from API: $e');
      rethrow;
    }
  }

  /// Get all lost posts by status from API.
  @override
  Future<List<LostPost>> getPostsByStatus(String status) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.LOST_POSTS,
        queryParams: {'status': status},
      );

      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => LostPost.fromMap(json)).toList();
    } catch (e) {
      print('Error fetching lost posts by status from API: $e');
      rethrow;
    }
  }

  /// Update post status via API (admin only).
  @override
  Future<int> updatePostStatus(dynamic postId, String status) async {
    try {
      await _apiClient.put(
        '${ApiConfig.ADMIN}/status/lost/$postId',
        body: {'status': status},
      );

      return 1; // Success
    } catch (e) {
      print('Error updating lost post status via API: $e');
      rethrow;
    }
  }

  /// Fetch statistics from API.
  Future<Map<String, int>> getStatistics() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.ADMIN}/statistics',
      );
      if (response['success'] == true) {
        return Map<String, int>.from(response['statistics']);
      }
      throw Exception(response['error'] ?? 'Failed to fetch statistics');
    } catch (e) {
      print('Error fetching lost statistics from API: $e');
      rethrow;
    }
  }

  /// Get all lost posts from API (admin only).
  Future<List<LostPost>> getAllPosts() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.LOST_POSTS_ALL,
      );

      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => LostPost.fromMap(json)).toList();
    } catch (e) {
      print('Error fetching all lost posts from API: $e');
      rethrow;
    }
  }

  /// Delete a lost post by ID via API.
  @override
  Future<int> deletePost(dynamic postId) async {
    try {
      await _apiClient.delete(
        '${ApiConfig.LOST_POSTS}/$postId',
      );

      return 1; // Success
    } catch (e) {
      print('Error deleting lost post via API: $e');
      rethrow;
    }
  }
}
