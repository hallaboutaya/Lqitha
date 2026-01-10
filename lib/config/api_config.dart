/// API Configuration for Lqitha App
/// 
/// Controls whether the app uses local SQLite database or remote Flask API.
/// Also contains API endpoint configurations.
class ApiConfig {
  // ==================== FEATURE FLAG ====================
  
  /// Set to true to use Flask API + Supabase PostgreSQL
  /// Set to false to use local SQLite database (default)
  static const bool USE_API = true;
  
  // ==================== API BASE URL ====================
  
  /// Base URL for Flask API
  /// Development: http://localhost:5000
  /// Production: https://your-api-domain.com
  static const String API_BASE_URL = 'https://backend-mobile-suva.onrender.com';
  
  // ==================== TIMEOUT CONFIGURATION ====================
  
  /// HTTP request timeout in seconds
  static const int REQUEST_TIMEOUT_SECONDS = 30;
  
  // ==================== API ENDPOINTS ====================
  
  // Authentication endpoints
  static const String AUTH_LOGIN = '/auth/login';
  static const String AUTH_REGISTER = '/auth/register';
  static const String AUTH_CHECK_EMAIL = '/auth/check-email';
  
  // Found posts endpoints
  static const String FOUND_POSTS = '/found-posts';
  static const String FOUND_POSTS_ALL = '/found-posts/all';
  
  // Lost posts endpoints
  static const String LOST_POSTS = '/lost-posts';
  static const String LOST_POSTS_ALL = '/lost-posts/all';
  
  // Notifications endpoints
  static const String NOTIFICATIONS = '/notifications';
  static const String NOTIFICATIONS_UNREAD_COUNT = '/notifications/unread-count';
  static const String NOTIFICATIONS_MARK_ALL_READ = '/notifications/mark-all-read';
  
  // Users endpoints
  static const String USERS = '/users';
  
  // Admin endpoints
  static const String ADMIN = '/admin';
  
  // ==================== HELPER METHODS ====================
  
  /// Get full URL for an endpoint
  static String getUrl(String endpoint) {
    return '$API_BASE_URL$endpoint';
  }
  
  /// Get URL for a specific resource by ID
  static String getUrlWithId(String endpoint, dynamic id) {
    return '$API_BASE_URL$endpoint/$id';
  }
}
