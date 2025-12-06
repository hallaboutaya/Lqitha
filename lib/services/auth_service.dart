/// Simple authentication service to manage the current logged-in user.
/// 
/// This is a basic implementation for development/testing purposes.
/// In production, you would integrate with a real authentication system.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  int? _currentUserId;
  String? _currentUserRole;

  /// Get the current logged-in user ID.
  /// Returns null if no user is logged in.
  int? get currentUserId => _currentUserId;

  /// Get the current logged-in user role.
  /// Returns null if no user is logged in.
  String? get currentUserRole => _currentUserRole;

  /// Check if a user is currently logged in.
  bool get isLoggedIn => _currentUserId != null;

  /// Login as a user with the specified ID and role.
  /// 
  /// For development:
  /// - User role: userId = 1 (Sarah Johnson)
  /// - Admin role: userId = 5 (Admin User)
  void login({required int userId, required String role}) {
    _currentUserId = userId;
    _currentUserRole = role;
    print('✅ Logged in as ${role} with userId: $userId');
  }

  /// Logout the current user.
  void logout() {
    _currentUserId = null;
    _currentUserRole = null;
    print('👋 Logged out');
  }

  /// Check if the current user is an admin.
  bool get isAdmin => _currentUserRole == 'admin';
}
