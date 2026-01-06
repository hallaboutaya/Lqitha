/// Custom exception types for better error handling
/// 
/// Provides specific exception types for different error scenarios,
/// allowing for better error handling and user-friendly error messages.
library;

/// Base exception class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  AppException(this.message, {this.code, this.originalError});
  
  @override
  String toString() => message;
}

/// Exception thrown when a network operation fails
class NetworkException extends AppException {
  NetworkException(
    super.message, {
    super.code,
    super.originalError,
  });
  
  /// Create a NetworkException from a generic error
  factory NetworkException.fromError(dynamic error) {
    if (error is NetworkException) return error;
    
    return NetworkException(
      'Connection error. Please check your internet connection.',
      code: 'NETWORK_ERROR',
      originalError: error,
    );
  }
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  ValidationException(
    super.message, {
    super.code,
    super.originalError,
  });
  
  /// Create a ValidationException for email validation
  factory ValidationException.invalidEmail() {
    return ValidationException(
      'Please enter a valid email address.',
      code: 'INVALID_EMAIL',
    );
  }
  
  /// Create a ValidationException for password validation
  factory ValidationException.weakPassword() {
    return ValidationException(
      'Password must be at least ${8} characters long.',
      code: 'WEAK_PASSWORD',
    );
  }
  
  /// Create a ValidationException for required field
  factory ValidationException.requiredField(String fieldName) {
    return ValidationException(
      '$fieldName is required.',
      code: 'REQUIRED_FIELD',
    );
  }
}

/// Exception thrown when authentication fails
class AuthenticationException extends AppException {
  AuthenticationException(
    super.message, {
    super.code,
    super.originalError,
  });
  
  /// Create an AuthenticationException for invalid credentials
  factory AuthenticationException.invalidCredentials() {
    return AuthenticationException(
      'Invalid email or password.',
      code: 'INVALID_CREDENTIALS',
    );
  }
  
  /// Create an AuthenticationException for expired token
  factory AuthenticationException.expiredToken() {
    return AuthenticationException(
      'Your session has expired. Please login again.',
      code: 'EXPIRED_TOKEN',
    );
  }
  
  /// Create an AuthenticationException for unauthorized access
  factory AuthenticationException.unauthorized() {
    return AuthenticationException(
      'You are not authorized to perform this action.',
      code: 'UNAUTHORIZED',
    );
  }
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  NotFoundException(
    super.message, {
    super.code,
    super.originalError,
  });
  
  /// Create a NotFoundException for a resource
  factory NotFoundException.resource(String resourceName) {
    return NotFoundException(
      '$resourceName not found.',
      code: 'RESOURCE_NOT_FOUND',
    );
  }
}

/// Exception thrown when an operation is not allowed
class ForbiddenException extends AppException {
  ForbiddenException(
    super.message, {
    super.code,
    super.originalError,
  });
  
  /// Create a ForbiddenException
  factory ForbiddenException.action() {
    return ForbiddenException(
      'You do not have permission to perform this action.',
      code: 'FORBIDDEN',
    );
  }
}

/// Exception thrown when a server error occurs
class ServerException extends AppException {
  ServerException(
    super.message, {
    super.code,
    super.originalError,
  });
  
  /// Create a ServerException
  factory ServerException.generic() {
    return ServerException(
      'Server error. Please try again later.',
      code: 'SERVER_ERROR',
    );
  }
}

/// Exception thrown when an image operation fails
class ImageException extends AppException {
  ImageException(
    super.message, {
    super.code,
    super.originalError,
  });
  
  /// Create an ImageException for file too large
  factory ImageException.fileTooLarge() {
    return ImageException(
      'Image file is too large. Maximum size is 5MB.',
      code: 'FILE_TOO_LARGE',
    );
  }
  
  /// Create an ImageException for invalid format
  factory ImageException.invalidFormat() {
    return ImageException(
      'Invalid image format. Please use JPG, PNG, or GIF.',
      code: 'INVALID_FORMAT',
    );
  }
  
  /// Create an ImageException for upload failure
  factory ImageException.uploadFailed() {
    return ImageException(
      'Failed to upload image. Please try again.',
      code: 'UPLOAD_FAILED',
    );
  }
}

/// Exception thrown when a database operation fails
class DatabaseException extends AppException {
  DatabaseException(
    super.message, {
    super.code,
    super.originalError,
  });
  
  /// Create a DatabaseException
  factory DatabaseException.operation(String operation) {
    return DatabaseException(
      'Database error during $operation. Please try again.',
      code: 'DATABASE_ERROR',
    );
  }
}

/// Helper class to get user-friendly error messages
class ErrorMessageHelper {
  /// Get a user-friendly error message from an exception
  static String getUserFriendlyMessage(AppException error) {
    if (error is NetworkException) {
      return 'Connection error. Please check your internet connection.';
    } else if (error is ValidationException) {
      return error.message; // Validation errors are already user-friendly
    } else if (error is AuthenticationException) {
      return error.message; // Auth errors are already user-friendly
    } else if (error is NotFoundException) {
      return error.message; // Not found errors are already user-friendly
    } else if (error is ForbiddenException) {
      return error.message; // Forbidden errors are already user-friendly
    } else if (error is ImageException) {
      return error.message; // Image errors are already user-friendly
    } else if (error is ServerException) {
      return 'Server error. Please try again later.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
  
  /// Get a user-friendly error message from any error
  static String fromError(dynamic error) {
    if (error is AppException) {
      return getUserFriendlyMessage(error);
    } else if (error is Exception) {
      return 'An error occurred: ${error.toString()}';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}

