import 'package:sqflite/sqflite.dart';
import '../../models/found_post.dart';
import '../found_repository.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';

/// API implementation of FoundRepository.
/// 
/// Makes HTTP calls to Flask API instead of querying local SQLite database.
/// Extends FoundRepository for seamless switching.
class ApiFoundRepository extends FoundRepository {
  final ApiClient _apiClient = ApiClient();
  
  // Override _db getter to prevent SQLite access (not used in API mode)
  @override
  Future<Database> get _db async => throw UnimplementedError('Use API methods instead of _db');

  /// Fetch all approved found posts from the API.
  @override
  Future<List<FoundPost>> getApprovedPosts() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.FOUND_POSTS,
        queryParams: {'status': 'approved'},
      );

      final List<dynamic>? postsJson = response['posts'];
      if (postsJson == null) {
        print('⚠️ API returned null posts, returning empty list');
        return [];
      }
      
      return postsJson.map((json) {
        try {
          return FoundPost.fromMap(json);
        } catch (e) {
          print('❌ Error parsing post: $e');
          print('   Post data: $json');
          return null;
        }
      }).whereType<FoundPost>().toList();
    } catch (e, stackTrace) {
      print('❌ Error fetching approved found posts from API: $e');
      print('📚 Stack trace: $stackTrace');
      // Return empty list instead of rethrowing to prevent UI crash
      return [];
    }
  }

  /// Search for approved found posts matching the query.
  Future<List<FoundPost>> searchPosts(String query) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.FOUND_POSTS,
        queryParams: {
          'status': 'approved',
          'search': query,
        },
      );

      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => FoundPost.fromMap(json)).toList();
    } catch (e) {
      print('Error searching found posts from API: $e');
      return [];
    }
  }

  /// Fetch all found posts for a specific user from API.
  @override
  Future<List<FoundPost>> getPostsByUserId(dynamic userId, {String? status}) async {
    try {
      Map<String, String> queryParams = {'user_id': userId.toString()};
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      final response = await _apiClient.get(
        ApiConfig.FOUND_POSTS,
        queryParams: queryParams,
      );

      final List<dynamic>? postsJson = response['posts'];
      if (postsJson == null) {
        return [];
      }
      
      return postsJson.map((json) {
        try {
          return FoundPost.fromMap(json);
        } catch (e) {
          print('❌ Error parsing post: $e');
          return null;
        }
      }).whereType<FoundPost>().toList();
    } catch (e, stackTrace) {
      print('❌ Error fetching posts by user id from API: $e');
      print('📚 Stack trace: $stackTrace');
      return [];
    }
  }

  /// Insert a new found post via API.
  /// 
  /// Returns the id of the newly created post.
  @override
  Future<dynamic> insertPost(FoundPost post) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.FOUND_POSTS,
        body: post.toMap(),
      );

      final createdPost = response['post'];
      return createdPost['id'];
    } catch (e) {
      print('Error inserting found post via API: $e');
      rethrow;
    }
  }

  /// Update an existing found post via API.
  /// 
  /// Returns the number of rows affected (1 on success).
  Future<int> updatePost(FoundPost post) async {
    try {
      if (post.id == null) {
        throw Exception('Cannot update post without id');
      }

      await _apiClient.put(
        '${ApiConfig.FOUND_POSTS}/${post.id}',
        body: {
          'photo': post.photo,
          'description': post.description,
          'location': post.location,
          'category': post.category,
        },
      );

      return 1; // Success
    } catch (e) {
      print('Error updating found post via API: $e');
      rethrow;
    }
  }

  /// Get a single found post by id from API.
  @override
  Future<FoundPost?> getPostById(dynamic id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.FOUND_POSTS}/$id',
      );

      final postJson = response['post'];
      return FoundPost.fromMap(postJson);
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        return null;
      }
      print('Error fetching found post by id from API: $e');
      rethrow;
    }
  }

  /// Get all found posts for a specific user from API.
  @override
  Future<List<FoundPost>> getPostsByUser(dynamic userId) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.FOUND_POSTS,
        queryParams: {'user_id': userId.toString()},
      );

      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => FoundPost.fromMap(json)).toList();
    } catch (e) {
      print('Error fetching user found posts from API: $e');
      rethrow;
    }
  }

  /// Get all found posts by status from API.
  @override
  Future<List<FoundPost>> getPostsByStatus(String status) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.FOUND_POSTS,
        queryParams: {'status': status},
      );

      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => FoundPost.fromMap(json)).toList();
    } catch (e) {
      print('Error fetching found posts by status from API: $e');
      rethrow;
    }
  }

  /// Update post status via API (admin only).
  @override
  Future<int> updatePostStatus(dynamic postId, String status) async {
    try {
      await _apiClient.put(
        '${ApiConfig.ADMIN}/status/found/$postId',
        body: {'status': status},
      );

      return 1; // Success
    } catch (e) {
      print('Error updating found post status via API: $e');
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
      print('Error fetching found statistics from API: $e');
      rethrow;
    }
  }

  /// Get all found posts from API (admin only).
  Future<List<FoundPost>> getAllPosts() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.FOUND_POSTS_ALL,
      );

      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => FoundPost.fromMap(json)).toList();
    } catch (e) {
      print('Error fetching all found posts from API: $e');
      rethrow;
    }
  }

  /// Delete a found post by ID via API.
  @override
  Future<int> deletePost(dynamic postId) async {
    try {
      await _apiClient.delete(
        '${ApiConfig.FOUND_POSTS}/$postId',
      );

      return 1; // Success
    } catch (e) {
      print('Error deleting found post via API: $e');
      rethrow;
    }
  }
}
