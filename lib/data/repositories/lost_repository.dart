import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/lost_post.dart';

/// Repository for Lost Posts database operations.
/// 
/// This repository handles all database interactions for lost items,
/// including fetching approved posts, searching, inserting new posts,
/// and updating existing posts. It follows the approval workflow where
/// new posts are created with 'pending' status and only 'approved' posts
/// are displayed to users.
class LostRepository {
  /// Get database instance from DBHelper
  Future<Database> get _db async => await DBHelper.getDatabase();

  /// Fetch all approved lost posts from the database.
  /// 
  /// Only posts with status='approved' will be returned, ensuring
  /// that pending posts waiting for admin approval are not shown to users.
  /// 
  /// Returns a list of [LostPost] objects ordered by creation date (newest first).
  Future<List<LostPost>> getApprovedPosts() async {
    try {
      final db = await _db;
      
      // Query only approved posts, ordered by creation date descending
      final List<Map<String, dynamic>> maps = await db.query(
        'lost_posts',
        where: 'status = ?',
        whereArgs: ['approved'],
        orderBy: 'created_at DESC',
      );

      // Convert database maps to LostPost objects
      return List.generate(maps.length, (i) {
        return LostPost.fromMap(maps[i]);
      });
    } catch (e) {
      // Log error and rethrow for cubit to handle
      print('Error fetching approved lost posts: $e');
      rethrow;
    }
  }

  /// Search for approved lost posts matching the query.
  /// 
  /// Searches in description, location, and category fields.
  /// Only searches within approved posts to maintain the approval workflow.
  /// 
  /// [query] - The search term to match against post fields
  /// 
  /// Returns a list of matching [LostPost] objects.
  Future<List<LostPost>> searchPosts(String query) async {
    try {
      final db = await _db;
      
      // Search only in approved posts
      // Using LIKE with wildcards for partial matching (case-insensitive on most SQLite)
      final List<Map<String, dynamic>> maps = await db.query(
        'lost_posts',
        where: 'status = ? AND (description LIKE ? OR location LIKE ? OR category LIKE ?)',
        whereArgs: [
          'approved',
          '%$query%',
          '%$query%',
          '%$query%',
        ],
        orderBy: 'created_at DESC',
      );

      // Convert to LostPost objects
      return List.generate(maps.length, (i) {
        return LostPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error searching lost posts: $e');
      rethrow;
    }
  }

  /// Insert a new lost post into the database.
  /// 
  /// The post will be created with status='pending' (default in database schema).
  /// It will NOT appear in user feeds until admin approves it and changes
  /// status to 'approved'.
  /// 
  /// [post] - The LostPost object to insert (id should be null)
  /// 
  /// Returns the id of the newly inserted post.
  Future<int> insertPost(LostPost post) async {
    try {
      final db = await _db;
      
      // Insert and return the new row id
      // The database will automatically set status='pending' as default
      final id = await db.insert(
        'lost_posts',
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('Successfully inserted lost post with id: $id');
      return id;
    } catch (e) {
      print('Error inserting lost post: $e');
      rethrow;
    }
  }

  /// Update an existing lost post in the database.
  /// 
  /// This allows users to edit their submitted posts.
  /// Note: This should only be used for updating post details,
  /// NOT for changing status (that's admin's responsibility).
  /// 
  /// [post] - The LostPost object with updated values (id must not be null)
  /// 
  /// Returns the number of rows affected (should be 1 on success).
  Future<int> updatePost(LostPost post) async {
    try {
      final db = await _db;
      
      if (post.id == null) {
        throw Exception('Cannot update post without id');
      }

      // Update the post by id
      final updatedRows = await db.update(
        'lost_posts',
        post.toMap(),
        where: 'id = ?',
        whereArgs: [post.id],
      );

      print('Successfully updated lost post id: ${post.id}');
      return updatedRows;
    } catch (e) {
      print('Error updating lost post: $e');
      rethrow;
    }
  }

  /// Get a single lost post by id.
  /// 
  /// Useful for viewing post details or editing.
  /// 
  /// [id] - The id of the post to fetch
  /// 
  /// Returns a [LostPost] object or null if not found.
  Future<LostPost?> getPostById(int id) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'lost_posts',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) {
        return null;
      }

      return LostPost.fromMap(maps.first);
    } catch (e) {
      print('Error fetching lost post by id: $e');
      rethrow;
    }
  }

  /// Get all lost posts for a specific user.
  /// 
  /// Returns posts regardless of status, so users can see their own
  /// pending/approved/rejected posts in their profile.
  /// 
  /// [userId] - The id of the user
  /// 
  /// Returns a list of [LostPost] objects for that user.
  Future<List<LostPost>> getPostsByUser(int userId) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'lost_posts',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return LostPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching user lost posts: $e');
      rethrow;
    }
  }

  /// Get all lost posts by status (for admin panel).
  /// 
  /// [status] - The status to filter by ('pending', 'approved', 'rejected')
  /// 
  /// Returns a list of [LostPost] objects with the specified status.
  Future<List<LostPost>> getPostsByStatus(String status) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'lost_posts',
        where: 'status = ?',
        whereArgs: [status],
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return LostPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching lost posts by status: $e');
      rethrow;
    }
  }

  /// Update post status (for admin approval/rejection).
  /// 
  /// [postId] - The id of the post to update
  /// [status] - The new status ('approved' or 'rejected')
  /// 
  /// Returns the number of rows affected (should be 1 on success).
  Future<int> updatePostStatus(int postId, String status) async {
    try {
      final db = await _db;
      
      final updatedRows = await db.update(
        'lost_posts',
        {'status': status},
        where: 'id = ?',
        whereArgs: [postId],
      );

      print('Successfully updated lost post $postId status to $status');
      return updatedRows;
    } catch (e) {
      print('Error updating lost post status: $e');
      rethrow;
    }
  }

  /// Get all lost posts (for admin panel - all statuses).
  /// 
  /// Returns all lost posts regardless of status.
  Future<List<LostPost>> getAllPosts() async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'lost_posts',
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return LostPost.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching all lost posts: $e');
      rethrow;
    }
  }

  /// Delete a lost post by ID.
  /// 
  /// [postId] - The id of the post to delete
  /// 
  /// Returns the number of rows affected (should be 1 on success).
  Future<int> deletePost(int postId) async {
    try {
      final db = await _db;
      
      final deletedRows = await db.delete(
        'lost_posts',
        where: 'id = ?',
        whereArgs: [postId],
      );

      print('Successfully deleted lost post $postId');
      return deletedRows;
    } catch (e) {
      print('Error deleting lost post: $e');
      rethrow;
    }
  }
}
