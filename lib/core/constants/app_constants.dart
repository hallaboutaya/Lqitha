/// Application-wide constants
/// 
/// Centralizes all magic numbers and configuration values used throughout the app.
library;

class AppConstants {
  // ============================================================================
  // PAYMENT & COSTS
  // ============================================================================
  /// Cost to unlock contact information (in DA - Algerian Dinars)
  static const int contactUnlockCost = 200;
  
  // ============================================================================
  // IMAGE CONFIGURATION
  // ============================================================================
  /// Maximum image size in bytes (5 MB)
  static const int maxImageSizeBytes = 5 * 1024 * 1024;
  
  /// Maximum image width for upload (pixels)
  static const int maxImageWidth = 1920;
  
  /// Maximum image height for upload (pixels)
  static const int maxImageHeight = 1080;
  
  /// Image quality for compression (0.0 to 1.0)
  static const double imageQuality = 0.85;
  
  // ============================================================================
  // VALIDATION
  // ============================================================================
  /// Minimum password length
  static const int minPasswordLength = 8;
  
  /// Maximum password length
  static const int maxPasswordLength = 128;
  
  /// Minimum username length
  static const int minUsernameLength = 3;
  
  /// Maximum username length
  static const int maxUsernameLength = 50;
  
  // ============================================================================
  // PAGINATION
  // ============================================================================
  /// Default number of items per page
  static const int defaultPageSize = 20;
  
  /// Maximum number of items per page
  static const int maxPageSize = 100;
  
  // ============================================================================
  // TIMEOUTS
  // ============================================================================
  /// Default HTTP request timeout in seconds
  static const int defaultRequestTimeoutSeconds = 30;
  
  /// Image upload timeout in seconds
  static const int imageUploadTimeoutSeconds = 60;
  
  // ============================================================================
  // UI CONSTANTS
  // ============================================================================
  /// Default border radius for cards
  static const double defaultBorderRadius = 16.0;
  
  /// Default padding for screens
  static const double defaultScreenPadding = 20.0;
  
  /// Default spacing between elements
  static const double defaultSpacing = 16.0;
  
  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================
  /// Default animation duration in milliseconds
  static const int defaultAnimationDurationMs = 300;
  
  /// Short animation duration in milliseconds
  static const int shortAnimationDurationMs = 150;
  
  /// Long animation duration in milliseconds
  static const int longAnimationDurationMs = 500;
  
  // ============================================================================
  // CACHE CONFIGURATION
  // ============================================================================
  /// Image cache max age in days
  static const int imageCacheMaxAgeDays = 7;
  
  /// Maximum number of cached images
  static const int maxCachedImages = 100;
  
  // ============================================================================
  // NOTIFICATION
  // ============================================================================
  /// Default notification display duration in seconds
  static const int defaultNotificationDurationSeconds = 4;
  
  /// Long notification display duration in seconds
  static const int longNotificationDurationSeconds = 6;
  
  // ============================================================================
  // RETRY CONFIGURATION
  // ============================================================================
  /// Maximum number of retry attempts for network requests
  static const int maxRetryAttempts = 3;
  
  /// Delay between retry attempts in milliseconds
  static const int retryDelayMs = 1000;
}

