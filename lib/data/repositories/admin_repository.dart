import '../databases/db_helper.dart';
import '../models/lost_post.dart';
import '../models/found_post.dart';

class AdminRepository {
  /// Get all pending lost posts with user information
  Future<List<LostPost>> getPendingLostPosts() async {
    final db = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT lp.*, u.username, u.photo as user_photo
      FROM lost_posts lp
      LEFT JOIN users u ON lp.user_id = u.id
      WHERE lp.status = ?
      ORDER BY lp.created_at DESC
    ''', ['pending']);
    
    return List.generate(maps.length, (i) => LostPost.fromMap(maps[i]));
  }

  /// Get all pending found posts with user information
  Future<List<FoundPost>> getPendingFoundPosts() async {
    final db = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT fp.*, u.username, u.photo as user_photo
      FROM found_posts fp
      LEFT JOIN users u ON fp.user_id = u.id
      WHERE fp.status = ?
      ORDER BY fp.created_at DESC
    ''', ['pending']);
    
    return List.generate(maps.length, (i) => FoundPost.fromMap(maps[i]));
  }

  /// Get all approved lost posts
  Future<List<LostPost>> getApprovedLostPosts() async {
    final db = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT lp.*, u.username, u.photo as user_photo
      FROM lost_posts lp
      LEFT JOIN users u ON lp.user_id = u.id
      WHERE lp.status = ?
      ORDER BY lp.created_at DESC
    ''', ['approved']);
    
    return List.generate(maps.length, (i) => LostPost.fromMap(maps[i]));
  }

  /// Get all approved found posts
  Future<List<FoundPost>> getApprovedFoundPosts() async {
    final db = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT fp.*, u.username, u.photo as user_photo
      FROM found_posts fp
      LEFT JOIN users u ON fp.user_id = u.id
      WHERE fp.status = ?
      ORDER BY fp.created_at DESC
    ''', ['approved']);
    
    return List.generate(maps.length, (i) => FoundPost.fromMap(maps[i]));
  }

  /// Get all rejected lost posts
  Future<List<LostPost>> getRejectedLostPosts() async {
    final db = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT lp.*, u.username, u.photo as user_photo
      FROM lost_posts lp
      LEFT JOIN users u ON lp.user_id = u.id
      WHERE lp.status = ?
      ORDER BY lp.created_at DESC
    ''', ['rejected']);
    
    return List.generate(maps.length, (i) => LostPost.fromMap(maps[i]));
  }

  /// Get all rejected found posts
  Future<List<FoundPost>> getRejectedFoundPosts() async {
    final db = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT fp.*, u.username, u.photo as user_photo
      FROM found_posts fp
      LEFT JOIN users u ON fp.user_id = u.id
      WHERE fp.status = ?
      ORDER BY fp.created_at DESC
    ''', ['rejected']);
    
    return List.generate(maps.length, (i) => FoundPost.fromMap(maps[i]));
  }

  /// Approve a post (update status to 'approved')
  Future<void> approvePost(dynamic id, String type) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      type == 'lost' ? 'lost_posts' : 'found_posts',
      {'status': 'approved'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Reject a post (update status to 'rejected')
  Future<void> rejectPost(dynamic id, String type) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      type == 'lost' ? 'lost_posts' : 'found_posts',
      {'status': 'rejected'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get statistics for the admin dashboard
  Future<Map<String, int>> getStatistics() async {
    final db = await DBHelper.getDatabase();
    
    // Count total posts
    final totalPostsResult = await db.rawQuery('''
      SELECT 
        (SELECT COUNT(*) FROM lost_posts) + 
        (SELECT COUNT(*) FROM found_posts) as total
    ''');
    final totalPosts = totalPostsResult.first['total'] as int;
    
    // Count pending posts
    final pendingResult = await db.rawQuery('''
      SELECT 
        (SELECT COUNT(*) FROM lost_posts WHERE status = 'pending') + 
        (SELECT COUNT(*) FROM found_posts WHERE status = 'pending') as pending
    ''');
    final pendingPosts = pendingResult.first['pending'] as int;
    
    // Count approved posts
    final approvedResult = await db.rawQuery('''
      SELECT 
        (SELECT COUNT(*) FROM lost_posts WHERE status = 'approved') + 
        (SELECT COUNT(*) FROM found_posts WHERE status = 'approved') as approved
    ''');
    final approvedPosts = approvedResult.first['approved'] as int;
    
    // Count active users (users who have posted)
    final activeUsersResult = await db.rawQuery('''
      SELECT COUNT(DISTINCT user_id) as active_users
      FROM (
        SELECT user_id FROM lost_posts
        UNION
        SELECT user_id FROM found_posts
      )
    ''');
    final activeUsers = activeUsersResult.first['active_users'] as int;
    
    return {
      'totalPosts': totalPosts,
      'pendingPosts': pendingPosts,
      'approvedToday': approvedPosts,
      'activeUsers': activeUsers,
    };
  }
}
