import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/found_post.dart';
import '../../core/models/paginated_result.dart';
import '../../core/constants/app_constants.dart';
import '../../core/logging/app_logger.dart';

/// Repository for Found Posts database operations.
/// 
/// This repository handles all database interactions for found items,
/// including fetching approved posts, searching, inserting new posts,
/// and updating existing posts. It follows the approval workflow where
/// new posts are created with 'pending' status and only 'approved' posts
/// are displayed to users.
class FoundRepository {
  /// Get database instance from DBHelper
  Future<Database> get _db async => await DBHelper.getDatabase();

  /// Fetch all approved found posts from the database.
  /// 
  /// Only posts with status='approved' will be returned, ensuring
  /// that pending posts waiting for admin approval are not shown to users.
  /// 
  /// Returns a list of [FoundPost] objects ordered by creation date (newest first).
  Future<List<FoundPost>> getApprovedPosts() async {
    try {
      final db = await _db;
      
      // Query only approved posts, ordered by creation date descending
      final List<Map<String, dynamic>> maps = await db.query(
        'found_posts',
        where: 'status = ?',
        whereArgs: ['approved'],
        orderBy: 'created_at DESC',
      );

      // Convert database maps to FoundPost objects
      return List.generate(maps.length, (i) {
        return FoundPost.fromMap(maps[i]);
      });
    } catch (e, stackTrace) {
      // Log error and rethrow for cubit to handle
      AppLogger.e('Error fetching approved found posts', e, stackTrace);
      rethrow;
    }
  }
  
  /// Fetch approved found posts with pagination
  /// 
  /// [page] - Page number (1-indexed)
  /// [pageSize] - Number of items per page
  /// 
  /// Returns a [PaginatedResult] with posts and pagination metadata
  Future<PaginatedResult<FoundPost>> getApprovedPostsPaginated({
    int page = 1,
    int pageSize = AppConstants.defaultPageSize,
  }) async {
    try {
      final db = await _db;
      
      // Get total count
      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM found_posts WHERE status = ?',
        ['approved'],
      );
      final total = countResult.first['count'] as int;
      
      // Calculate offset
      final offset = (page - 1) * pageSize;
      
      // Query with pagination
      final List<Map<String, dynamic>> maps = await db.query(
        'found_posts',
        where: 'status = ?',
        whereArgs: ['approved'],
        orderBy: 'created_at DESC',
        limit: pageSize,
        offset: offset,
      );
      
      // Convert to FoundPost objects
      final items = List.generate(maps.length, (i) {
        return FoundPost.fromMap(maps[i]);
      });
      
      return PaginatedResult<FoundPost>(
        items: items,
        total: total,
        page: page,
        pageSize: pageSize,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Error fetching paginated found posts', e, stackTrace);
      rethrow;
    }
  }

  /// Search for approved found posts matching the query.
  /// 
  /// Searches in description, location, and category fields.
  /// Only searches within approved posts to maintain the approval workflow.
  /// 
  /// [query] - The search term to match against post fields
  /// 
  /// Returns a list of matching [FoundPost] objects.
  Future<List<FoundPost>> searchPosts(String query) async {
    try {
      final db = await _db;
      
      // Search only in approved posts
      // Using LIKE with wildcards for partial matching (case-insensitive on most SQLite)
      final List<Map<String, dynamic>> maps = await db.query(
        'found_posts',
        where: 'status = ? AND (description LIKE ? OR location LIKE ? OR category LIKE ?)',
        whereArgs: [
          'approved',
          '%$query%',
          '%$query%',
          '%$query%',
        ],
        orderBy: 'created_at DESC',
      );

      // Convert to FoundPost objects
      return List.generate(maps.length, (i) {
        return FoundPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error searching found posts: $e');
      rethrow;
    }
  }

  /// Fetch all found posts for a specific user.
  /// 
  /// Optionally filter by status (e.g., 'approved', 'pending', 'rejected').
  /// 
  /// [userId] - The id of the user
  /// [status] - Optional status filter
  /// 
  /// Returns a list of [FoundPost] objects.
  Future<List<FoundPost>> getPostsByUserId(dynamic userId, {String? status}) async {
    try {
      final db = await _db;
      
      String whereClause = 'user_id = ?';
      List<dynamic> whereArgs = [userId];
      
      if (status != null) {
        whereClause += ' AND status = ?';
        whereArgs.add(status);
      }
      
      final List<Map<String, dynamic>> maps = await db.query(
        'found_posts',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return FoundPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching posts by user id: $e');
      rethrow;
    }
  }

  /// Insert a new found post into the database.
  /// 
  /// The post will be created with status='pending' (default in database schema).
  /// It will NOT appear in user feeds until admin approves it and changes
  /// status to 'approved'.
  /// 
  /// [post] - The FoundPost object to insert (id should be null)
  /// 
  /// Returns the id of the newly inserted post.
  Future<dynamic> insertPost(FoundPost post) async {
    try {
      final db = await _db;
      
      // Insert and return the new row id
      // The database will automatically set status='pending' as default
      final id = await db.insert(
        'found_posts',
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('Successfully inserted found post with id: $id');
      return id;
    } catch (e) {
      print('Error inserting found post: $e');
      rethrow;
    }
  }

  /// Update an existing found post in the database.
  /// 
  /// This allows users to edit their submitted posts.
  /// Note: This should only be used for updating post details,
  /// NOT for changing status (that's admin's responsibility).
  /// 
  /// [post] - The FoundPost object with updated values (id must not be null)
  /// 
  /// Returns the number of rows affected (should be 1 on success).
  Future<int> updatePost(FoundPost post) async {
    try {
      final db = await _db;
      
      if (post.id == null) {
        throw Exception('Cannot update post without id');
      }

      // Update the post by id
      final updatedRows = await db.update(
        'found_posts',
        post.toMap(),
        where: 'id = ?',
        whereArgs: [post.id],
      );

      print('Successfully updated found post id: ${post.id}');
      return updatedRows;
    } catch (e) {
      print('Error updating found post: $e');
      rethrow;
    }
  }

  /// Get a single found post by id.
  /// 
  /// Useful for viewing post details or editing.
  /// 
  /// [id] - The id of the post to fetch
  /// 
  /// Returns a [FoundPost] object or null if not found.
  Future<FoundPost?> getPostById(dynamic id) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'found_posts',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) {
        return null;
      }

      return FoundPost.fromMap(maps.first);
    } catch (e) {
      print('Error fetching found post by id: $e');
      rethrow;
    }
  }

  /// Get all found posts for a specific user.
  /// 
  /// Returns posts regardless of status, so users can see their own
  /// pending/approved/rejected posts in their profile.
  /// 
  /// [userId] - The id of the user
  /// 
  /// Returns a list of [FoundPost] objects for that user.
  Future<List<FoundPost>> getPostsByUser(dynamic userId) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'found_posts',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return FoundPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching user found posts: $e');
      rethrow;
    }
  }

  /// Get all found posts by status (for admin panel).
  /// 
  /// [status] - The status to filter by ('pending', 'approved', 'rejected')
  /// 
  /// Returns a list of [FoundPost] objects with the specified status.
  Future<List<FoundPost>> getPostsByStatus(String status) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'found_posts',
        where: 'status = ?',
        whereArgs: [status],
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return FoundPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching found posts by status: $e');
      rethrow;
    }
  }

  /// Update post status (for admin approval/rejection).
  /// 
  /// [postId] - The id of the post to update
  /// [status] - The new status ('approved' or 'rejected')
  /// 
  /// Returns the number of rows affected (should be 1 on success).
  Future<int> updatePostStatus(dynamic postId, String status) async {
    try {
      final db = await _db;
      
      final updatedRows = await db.update(
        'found_posts',
        {'status': status},
        where: 'id = ?',
        whereArgs: [postId],
      );

      print('Successfully updated found post $postId status to $status');
      return updatedRows;
    } catch (e) {
      print('Error updating found post status: $e');
      rethrow;
    }
  }

  /// Get all found posts (for admin panel - all statuses).
  /// 
  /// Returns all found posts regardless of status.
  Future<List<FoundPost>> getAllPosts() async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'found_posts',
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return FoundPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching all found posts: $e');
      rethrow;
    }
  }

  /// Mark a found post as done (resolved/returned).
  /// 
  /// [postId] - The id of the post to update
  /// 
  /// Returns the number of rows affected.
  Future<int> markAsDone(dynamic postId) async {
    try {
      final db = await _db;
      
      final updatedRows = await db.update(
        'found_posts',
        {'status': 'done'},
        where: 'id = ?',
        whereArgs: [postId],
      );

      print('Successfully marked found post $postId as done');
      return updatedRows;
    } catch (e) {
      print('Error marking found post as done: $e');
      rethrow;
    }
  }

  /// Delete a found post by ID.
  /// 
  /// [postId] - The id of the post to delete
  /// 
  /// Returns the number of rows affected (should be 1 on success).
  Future<int> deletePost(dynamic postId) async {
    try {
      final db = await _db;
      
      final deletedRows = await db.delete(
        'found_posts',
        where: 'id = ?',
        whereArgs: [postId],
      );

      print('Successfully deleted found post $postId');
      return deletedRows;
    } catch (e) {
      print('Error deleting found post: $e');
      rethrow;
    }
  }
}
