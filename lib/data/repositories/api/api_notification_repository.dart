import 'package:sqflite/sqflite.dart';
import '../../models/notification.dart';
import '../notification_repository.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';

/// API implementation of NotificationRepository.
/// 
/// Makes HTTP calls to Flask API instead of querying local SQLite database.
/// Extends NotificationRepository for seamless switching.
class ApiNotificationRepository extends NotificationRepository {
  final ApiClient _apiClient = ApiClient();
  
  // Override _db getter to prevent SQLite access (not used in API mode)
  @override
  Future<Database> get _db async => throw UnimplementedError('Use API methods instead of _db');

  /// Fetch all notifications for a specific user from API.
  @override
  Future<List<NotificationModel>> getAllNotifications(dynamic userId) async {
    try {
      print('🗄️  ApiNotificationRepository: Fetching notifications for userId=$userId');

      final response = await _apiClient.get(
        ApiConfig.NOTIFICATIONS,
        queryParams: {'user_id': userId.toString()},
      );

      final List<dynamic> notificationsJson = response['notifications'];
      print('🗄️  ApiNotificationRepository: Found ${notificationsJson.length} notifications');

      return notificationsJson
          .map((json) => NotificationModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Error fetching all notifications from API: $e');
      rethrow;
    }
  }

  /// Fetch only unread notifications for a specific user from API.
  @override
  Future<List<NotificationModel>> getUnreadNotifications(dynamic userId) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.NOTIFICATIONS,
        queryParams: {
          'user_id': userId.toString(),
          'unread': 'true',
        },
      );

      final List<dynamic> notificationsJson = response['notifications'];
      return notificationsJson
          .map((json) => NotificationModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Error fetching unread notifications from API: $e');
      rethrow;
    }
  }

  /// Mark a single notification as read via API.
  @override
  Future<void> markAsRead(dynamic notificationId) async {
    try {
      await _apiClient.put(
        '${ApiConfig.NOTIFICATIONS}/$notificationId/read',
        body: {},
      );
      
      print('Successfully marked notification $notificationId as read via API');
      // No return value needed for void
    } catch (e) {
      print('Error marking notification as read via API: $e');
      rethrow;
    }
  }

  /// Mark all notifications as read for a specific user via API.
  @override
  Future<int> markAllAsRead(dynamic userId) async {
    try {
      final response = await _apiClient.put(
        ApiConfig.NOTIFICATIONS_MARK_ALL_READ,
        body: {},
        requiresAuth: true,
      );

      // Return number of updated rows if provided, otherwise 1 for success
      return response['updated_count'] ?? 1;
    } catch (e) {
      print('Error marking all notifications as read via API: $e');
      rethrow;
    }
  }

  /// Insert a new notification via API.
  @override
  Future<dynamic> insertNotification(NotificationModel notification) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.NOTIFICATIONS,
        body: notification.toMap(),
      );

      final createdNotification = response['notification'];
      return createdNotification['id'];
    } catch (e) {
      print('Error inserting notification via API: $e');
      rethrow;
    }
  }

  /// Get the count of unread notifications for a user from API.
  @override
  Future<int> getUnreadCount(dynamic userId) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.NOTIFICATIONS_UNREAD_COUNT,
        queryParams: {'user_id': userId.toString()},
      );

      return response['count'] ?? 0;
    } catch (e) {
      print('Error getting unread count from API: $e');
      rethrow;
    }
  }

  /// Get notifications by type for a user from API.
  @override
  Future<List<NotificationModel>> getNotificationsByType(
    dynamic userId,
    String type,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.NOTIFICATIONS,
        queryParams: {
          'user_id': userId.toString(),
          'type': type,
        },
      );

      final List<dynamic> notificationsJson = response['notifications'];
      return notificationsJson
          .map((json) => NotificationModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Error fetching notifications by type from API: $e');
      rethrow;
    }
  }
}
