import 'package:shared_preferences/shared_preferences.dart';
import '../core/logging/app_logger.dart';

/// Authentication service to manage the current logged-in user.
/// 
/// Handles session persistence using SharedPreferences.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _keyUserId = 'user_id';
  static const String _keyUserRole = 'user_role';

  dynamic _currentUserId; // Can be int (SQLite) or String (Supabase UUID)
  String? _currentUserRole;

  /// Get the current logged-in user ID.
  /// Returns null if no user is logged in.
  /// Can be int (SQLite) or String (Supabase UUID)
  dynamic get currentUserId => _currentUserId;

  /// Get the current logged-in user role.
  /// Returns null if no user is logged in.
  String? get currentUserRole => _currentUserRole;

  /// Check if a user is currently logged in.
  bool get isLoggedIn => _currentUserId != null;

  /// Check if the current user is an admin.
  bool get isAdmin => _currentUserRole == 'admin';

  /// Login as a user with the specified ID and role.
  /// Saves session to SharedPreferences.
  /// [userId] can be int (SQLite) or String (Supabase UUID)
  Future<void> login({required dynamic userId, required String role}) async {
    _currentUserId = userId;
    _currentUserRole = role;
    await _saveSession();
    AppLogger.i('✅ Logged in as $role with userId: $userId');
  }

  /// Logout the current user.
  /// Clears session from SharedPreferences.
  Future<void> logout() async {
    _currentUserId = null;
    _currentUserRole = null;
    await clearSession();
    AppLogger.i('👋 Logged out');
  }

  /// Load session from SharedPreferences.
  Future<void> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Try to load as int first (SQLite), then as String (Supabase UUID)
      _currentUserId = prefs.getInt(_keyUserId) ?? prefs.getString(_keyUserId);
      _currentUserRole = prefs.getString(_keyUserRole);
      
      if (_currentUserId != null) {
        AppLogger.d('📱 Session loaded: userId=$_currentUserId, role=$_currentUserRole');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Failed to load session', e, stackTrace);
    }
  }

  /// Save session to SharedPreferences.
  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUserId != null) {
        // Save as int if it's an int, otherwise as String (UUID)
        if (_currentUserId is int) {
          await prefs.setInt(_keyUserId, _currentUserId as int);
        } else {
          await prefs.setString(_keyUserId, _currentUserId.toString());
        }
      }
      if (_currentUserRole != null) {
        await prefs.setString(_keyUserRole, _currentUserRole!);
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Failed to save session', e, stackTrace);
    }
  }

  /// Clear session from SharedPreferences.
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyUserRole);
    } catch (e, stackTrace) {
      AppLogger.e('❌ Failed to clear session', e, stackTrace);
    }
  }
}
