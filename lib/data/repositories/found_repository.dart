import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/found_post.dart';

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
    } catch (e) {
      // Log error and rethrow for cubit to handle
      print('Error fetching approved found posts: $e');
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

  /// Insert a new found post into the database.
  /// 
  /// The post will be created with status='pending' (default in database schema).
  /// It will NOT appear in user feeds until admin approves it and changes
  /// status to 'approved'.
  /// 
  /// [post] - The FoundPost object to insert (id should be null)
  /// 
  /// Returns the id of the newly inserted post.
  Future<int> insertPost(FoundPost post) async {
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
  Future<FoundPost?> getPostById(int id) async {
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
  Future<List<FoundPost>> getPostsByUser(int userId) async {
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
}
