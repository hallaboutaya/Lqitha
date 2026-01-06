import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/user.dart';

/// Repository for User database operations.
class UserRepository {
  /// Get database instance from DBHelper
  Future<Database> get _db async => await DBHelper.getDatabase();

  /// Get a user by ID.
  /// 
  /// [userId] - The id of the user (int for SQLite, String for Supabase UUID)
  /// 
  /// Returns a [User] object or null if not found.
  Future<User?> getUserById(dynamic userId) async {
    try {
      final db = await _db;
      
      // Handle both int and String IDs
      final idValue = userId is String ? int.tryParse(userId) ?? userId : userId;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [idValue],
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
  /// [userId] - The id of the user (int for SQLite, String for Supabase UUID)
  /// 
  /// Returns the username or null if not found.
  Future<String?> getUsernameById(dynamic userId) async {
    try {
      final db = await _db;
      
      // Handle both int and String IDs
      final idValue = userId is String ? int.tryParse(userId) ?? userId : userId;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        columns: ['username'],
        where: 'id = ?',
        whereArgs: [idValue],
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
      
      // Try to parse as int for SQLite, otherwise use as-is for UUID
      dynamic queryId = userId;
      try {
        queryId = int.parse(userId);
      } catch (e) {
        // Keep as string (UUID)
        queryId = userId;
      }
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [queryId],
        limit: 1,
      );

      if (maps.isEmpty) {
        print('⚠️ UserRepository: No user found with id=$queryId');
        return null;
      }

      // Ensure id is int, not String (for SQLite compatibility)
      final userMap = Map<String, dynamic>.from(maps.first);
      if (userMap['id'] is String) {
        try {
          userMap['id'] = int.parse(userMap['id'] as String);
        } catch (e) {
          // Keep as string (UUID)
        }
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

  // ==================== AUTHENTICATION METHODS ====================

  /// Validate user credentials for login.
  /// 
  /// [email] - User's email
  /// [password] - User's password
  /// 
  /// Returns the [User] object if credentials are valid, null otherwise.
  Future<User?> validateCredentials(String email, String password) async {
    try {
      print('🔍 UserRepository: validateCredentials called');
      print('📧 Email: $email');
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
        limit: 1,
      );

      print('📊 UserRepository: Found ${maps.length} matching users');
      if (maps.isEmpty) {
        print('❌ UserRepository: No user found with these credentials');
        return null;
      }

      final user = User.fromMap(maps.first);
      print('✅ UserRepository: User found: ${user.username} (id=${user.id})');
      return user;
    } catch (e, stackTrace) {
      print('❌ UserRepository: Error validating credentials: $e');
      print('📚 Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Check if an email already exists in the database.
  /// 
  /// [email] - Email to check
  /// 
  /// Returns true if email exists, false otherwise.
  Future<bool> emailExists(String email) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        columns: ['id'],
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      print('Error checking email existence: $e');
      rethrow;
    }
  }

  /// Create a new user account.
  /// 
  /// [user] - User object with registration data
  /// 
  /// Returns the ID of the newly created user.
  Future<dynamic> createUser(User user) async {
    try {
      print('🔍 UserRepository: createUser called');
      print('👤 Username: ${user.username}, Email: ${user.email}');
      final db = await _db;
      
      final userId = await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      print('✅ UserRepository: User created with ID: $userId');
      return userId;
    } catch (e, stackTrace) {
      print('❌ UserRepository: Error creating user: $e');
      print('📚 Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get user by email.
  /// 
  /// [email] - User's email
  /// 
  /// Returns the [User] object or null if not found.
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (maps.isEmpty) {
        return null;
      }

      return User.fromMap(maps.first);
    } catch (e) {
      print('Error fetching user by email: $e');
      rethrow;
    }
  }
  /// Update user's FCM token.
  Future<void> updateFCMToken(dynamic userId, String fcmToken) async {
    try {
      final db = await _db;
      final idValue = userId is String ? int.tryParse(userId) ?? userId : userId;
      
      await db.update(
        'users',
        {'fcm_token': fcmToken, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [idValue],
      );
    } catch (e) {
      print('Error updating FCM token: $e');
      rethrow;
    }
  }
}
