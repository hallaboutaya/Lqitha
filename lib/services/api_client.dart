import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// HTTP client service for making API calls to Flask backend.
/// 
/// Handles all HTTP requests, response parsing, error handling,
/// and authentication token management.
class ApiClient {
  /// Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  /// Authentication token (stored after login)
  String? _authToken;

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
    print('🔐 ApiClient: Auth token set');
  }

  /// Clear authentication token (logout)
  void clearAuthToken() {
    _authToken = null;
    print('🔐 ApiClient: Auth token cleared');
  }

  /// Get authentication token
  String? get authToken => _authToken;

  /// Get headers for authenticated requests
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  /// Make a GET request
  /// 
  /// [endpoint] - API endpoint (e.g., '/found-posts')
  /// [queryParams] - Optional query parameters
  /// [requiresAuth] - Whether this endpoint requires authentication
  /// 
  /// Returns the response body as a Map
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      // Build URL with query parameters
      final uri = Uri.parse(ApiConfig.getUrl(endpoint))
          .replace(queryParameters: queryParams);

      print('📡 GET: $uri');

      final response = await http
          .get(
            uri,
            headers: _getHeaders(includeAuth: requiresAuth),
          )
          .timeout(
            Duration(seconds: ApiConfig.REQUEST_TIMEOUT_SECONDS),
          );

      return _handleResponse(response);
    } catch (e) {
      print('❌ GET Error: $e');
      rethrow;
    }
  }

  /// Make a POST request
  /// 
  /// [endpoint] - API endpoint
  /// [body] - Request body as Map
  /// [requiresAuth] - Whether this endpoint requires authentication
  /// 
  /// Returns the response body as a Map
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    try {
      final url = ApiConfig.getUrl(endpoint);
      print('📡 POST: $url');
      print('📤 Body: ${jsonEncode(body)}');

      final response = await http
          .post(
            Uri.parse(url),
            headers: _getHeaders(includeAuth: requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(
            Duration(seconds: ApiConfig.REQUEST_TIMEOUT_SECONDS),
          );

      return _handleResponse(response);
    } catch (e) {
      print('❌ POST Error: $e');
      rethrow;
    }
  }

  /// Make a PUT request
  /// 
  /// [endpoint] - API endpoint
  /// [body] - Request body as Map
  /// [requiresAuth] - Whether this endpoint requires authentication
  /// 
  /// Returns the response body as a Map
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    try {
      final url = ApiConfig.getUrl(endpoint);
      print('📡 PUT: $url');
      print('📤 Body: ${jsonEncode(body)}');

      final response = await http
          .put(
            Uri.parse(url),
            headers: _getHeaders(includeAuth: requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(
            Duration(seconds: ApiConfig.REQUEST_TIMEOUT_SECONDS),
          );

      return _handleResponse(response);
    } catch (e) {
      print('❌ PUT Error: $e');
      rethrow;
    }
  }

  /// Make a DELETE request
  /// 
  /// [endpoint] - API endpoint
  /// [requiresAuth] - Whether this endpoint requires authentication
  /// 
  /// Returns the response body as a Map
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final url = ApiConfig.getUrl(endpoint);
      print('📡 DELETE: $url');

      final response = await http
          .delete(
            Uri.parse(url),
            headers: _getHeaders(includeAuth: requiresAuth),
          )
          .timeout(
            Duration(seconds: ApiConfig.REQUEST_TIMEOUT_SECONDS),
          );

      return _handleResponse(response);
    } catch (e) {
      print('❌ DELETE Error: $e');
      rethrow;
    }
  }

  /// Handle HTTP response and parse JSON
  /// 
  /// Throws exceptions for error status codes
  Map<String, dynamic> _handleResponse(http.Response response) {
    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    // Parse JSON response
    final Map<String, dynamic> data = jsonDecode(response.body);

    // Check status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success (2xx)
      return data;
    } else if (response.statusCode == 401) {
      // Unauthorized
      throw ApiException(
        'Authentication failed. Please login again.',
        statusCode: 401,
      );
    } else if (response.statusCode == 403) {
      // Forbidden
      throw ApiException(
        'You do not have permission to perform this action.',
        statusCode: 403,
      );
    } else if (response.statusCode == 404) {
      // Not found
      throw ApiException(
        data['error'] ?? 'Resource not found.',
        statusCode: 404,
      );
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      // Client error (4xx)
      throw ApiException(
        data['error'] ?? 'Invalid request.',
        statusCode: response.statusCode,
      );
    } else {
      // Server error (5xx)
      throw ApiException(
        'Server error. Please try again later.',
        statusCode: response.statusCode,
      );
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, {required this.statusCode});

  @override
  String toString() => 'ApiException ($statusCode): $message';
}
