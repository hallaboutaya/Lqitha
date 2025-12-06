import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/user.dart';

/// Repository for User database operations.
class UserRepository {
  /// Get database instance from DBHelper
  Future<Database> get _db async => await DBHelper.getDatabase();

  /// Get a user by ID.
  /// 
  /// [userId] - The id of the user
  /// 
  /// Returns a [User] object or null if not found.
  Future<User?> getUserById(int userId) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      if (maps.isEmpty) {
        return null;
      }

      return User.fromMap(maps.first);
    } catch (e) {
      print('Error fetching user by id: $e');
      rethrow;
    }
  }

  /// Get username by user ID (lightweight query).
  /// 
  /// [userId] - The id of the user
  /// 
  /// Returns the username or null if not found.
  Future<String?> getUsernameById(int userId) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        columns: ['username'],
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      if (maps.isEmpty) {
        return null;
      }

      return maps.first['username'] as String?;
    } catch (e) {
      print('Error fetching username by id: $e');
      return null;
    }
  }

  /// Get user profile by user ID (supports String ID for compatibility).
  /// 
  /// [userId] - The id of the user as a String
  /// 
  /// Returns a [User] object or null if not found.
  Future<User?> getUserProfile(String userId) async {
    try {
      print('📊 UserRepository: Getting profile for userId=$userId');
      final db = await _db;
      
      final int parsedId = int.parse(userId);
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [parsedId],
        limit: 1,
      );

      if (maps.isEmpty) {
        print('⚠️ UserRepository: No user found with id=$parsedId');
        return null;
      }

      // Ensure id is int, not String
      final userMap = Map<String, dynamic>.from(maps.first);
      if (userMap['id'] is String) {
        userMap['id'] = int.parse(userMap['id'] as String);
      }

      final user = User.fromMap(userMap);
      print('✅ UserRepository: Found user ${user.username} (id=${user.id})');
      return user;
    } catch (e) {
      print('❌ UserRepository: Error fetching user profile: $e');
      rethrow;
    }
  }

  /// Update user profile information.
  /// 
  /// [userId] - The id of the user
  /// [username] - New username
  /// [email] - New email
  /// [phoneNumber] - New phone number (optional)
  /// [photo] - Photo path (optional)
  Future<void> updateUserProfile({
    required String userId,
    required String username,
    required String email,
    String? phoneNumber,
    String? photo,
  }) async {
    try {
      final db = await _db;
      final current = await getUserProfile(userId);
      if (current == null) throw Exception("User not found");

      final updatedUser = User(
        id: current.id,
        username: username,
        email: email,
        password: current.password,
        phoneNumber: phoneNumber ?? current.phoneNumber,
        photo: photo ?? current.photo,
        role: current.role,
        points: current.points,
        createdAt: current.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await db.update(
        'users',
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [current.id],
      );
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  /// Update user profile photo.
  /// 
  /// [userId] - The id of the user
  /// [photoPath] - Path to the new photo
  Future<void> updateUserPhoto(String userId, String photoPath) async {
    try {
      final user = await getUserProfile(userId);
      if (user == null) throw Exception("User not found");
      
      await updateUserProfile(
        userId: userId,
        username: user.username,
        email: user.email,
        phoneNumber: user.phoneNumber,
        photo: photoPath,
      );
    } catch (e) {
      print('Error updating user photo: $e');
      rethrow;
    }
  }
}
