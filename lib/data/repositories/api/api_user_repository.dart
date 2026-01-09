import 'package:sqflite/sqflite.dart';
import '../../models/user.dart';
import '../user_repository.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';

/// API implementation of UserRepository.
/// 
/// Makes HTTP calls to Flask API instead of querying local SQLite database.
/// Extends UserRepository for seamless switching.
class ApiUserRepository extends UserRepository {
  final ApiClient _apiClient = ApiClient();
  
  // Override _db getter to prevent SQLite access (not used in API mode)
  @override
  Future<Database> get _db async => throw UnimplementedError('Use API methods instead of _db');

  /// Get a user by ID from API.
  /// Supports both int (SQLite) and String (Supabase UUID) IDs.
  @override
  Future<User?> getUserById(dynamic userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.USERS}/$userId',
      );

      final userJson = response['user'];
      return User.fromMap(userJson);
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        return null;
      }
      print('Error fetching user by id from API: $e');
      rethrow;
    }
  }

  /// Get username by user ID from API (lightweight query).
  /// Supports both int (SQLite) and String (Supabase UUID) IDs.
  @override
  Future<String?> getUsernameById(dynamic userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.USERS}/$userId/username',
      );

      return response['username'];
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        return null;
      }
      print('Error fetching username by id from API: $e');
      return null;
    }
  }

  /// Get user profile by user ID from API.
  @override
  Future<User?> getUserProfile(String userId) async {
    try {
      print('📊 ApiUserRepository: Getting profile for userId=$userId');

      final response = await _apiClient.get(
        '${ApiConfig.USERS}/$userId',
      );

      final userJson = response['user'];
      final user = User.fromMap(userJson);

      print('✅ ApiUserRepository: Found user ${user.username} (id=${user.id})');
      return user;
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        print('⚠️ ApiUserRepository: No user found with id=$userId');
        return null;
      }
      print('❌ ApiUserRepository: Error fetching user profile: $e');
      rethrow;
    }
  }

  /// Update user profile information via API.
  @override
  Future<void> updateUserProfile({
    required String userId,
    required String username,
    required String email,
    String? phoneNumber,
    String? photo,
  }) async {
    try {
      await _apiClient.put(
        '${ApiConfig.USERS}/$userId',
        body: {
          'username': username,
          'email': email,
          'phone_number': phoneNumber,
          'photo': photo,
        },
      );
    } catch (e) {
      print('Error updating user profile via API: $e');
      rethrow;
    }
  }

  /// Update user profile photo via API.
  @override
  Future<void> updateUserPhoto(String userId, String photoPath) async {
    try {
      await _apiClient.put(
        '${ApiConfig.USERS}/$userId/photo',
        body: {'photo': photoPath},
      );
    } catch (e) {
      print('Error updating user photo via API: $e');
      rethrow;
    }
  }

  // ==================== AUTHENTICATION METHODS ====================

  /// Validate user credentials for login via API.
  /// 
  /// Returns the User object if credentials are valid, null otherwise.
  /// Also stores the authentication token for subsequent requests.
  @override
  Future<User?> validateCredentials(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.AUTH_LOGIN,
        body: {
          'email': email,
          'password': password,
        },
        requiresAuth: false, // Login doesn't require auth
      );

      if (response['success'] == true) {
        // Store authentication token
        final token = response['token'];
        _apiClient.setAuthToken(token);

        // Return user object
        final userJson = response['user'];
        return User.fromMap(userJson);
      }

      return null;
    } catch (e) {
      print('Error validating credentials via API: $e');
      return null;
    }
  }

  /// Check if an email already exists via API.
  @override
  Future<bool> emailExists(String email) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.AUTH_CHECK_EMAIL,
        queryParams: {'email': email},
        requiresAuth: false,
      );

      return response['exists'] ?? false;
    } catch (e) {
      print('Error checking email existence via API: $e');
      rethrow;
    }
  }

  /// Create a new user account via API.
  /// 
  /// Returns the ID of the newly created user.
  @override
  Future<dynamic> createUser(User user) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.AUTH_REGISTER,
        body: user.toMap(),
        requiresAuth: false, // Registration doesn't require auth
      );

      if (response['success'] == true) {
        // Store authentication token
        final token = response['token'];
        _apiClient.setAuthToken(token);

        // Return user ID
        final userJson = response['user'];
        return userJson['id'];
      }

      throw Exception('Registration failed');
    } catch (e) {
      print('Error creating user via API: $e');
      rethrow;
    }
  }

  /// Get user by email from API.
  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.USERS}/by-email',
        queryParams: {'email': email},
      );

      final userJson = response['user'];
      return User.fromMap(userJson);
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        return null;
      }
      print('Error fetching user by email from API: $e');
      rethrow;
    }
  }

  /// Change user password via API.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        '${ApiConfig.USERS}/change-password',
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      print('Error changing password via API: $e');
      rethrow;
    }
  }

  /// Update user's FCM token via API.
  @override
  Future<void> updateFCMToken(dynamic userId, String fcmToken) async {
    try {
      await _apiClient.post(
        '${ApiConfig.USERS}/fcm-token',
        body: {'fcm_token': fcmToken},
      );
    } catch (e) {
      print('Error updating FCM token via API: $e');
      rethrow;
    }
  }
}
