import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/notification.dart';

/// Repository for Notifications database operations.
/// 
/// This repository handles all database interactions for notifications,
/// including fetching notifications for a user, marking notifications as read,
/// and creating new notifications. Notifications inform users about actions
/// related to their posts (e.g., someone found their lost item).
class NotificationRepository {
  /// Get database instance from DBHelper
  Future<Database> get _db async => await DBHelper.getDatabase();

  /// Fetch all notifications for a specific user.
  /// 
  /// Returns all notifications (both read and unread) for the user,
  /// ordered by creation date (newest first).
  /// 
  /// [userId] - The id of the user to fetch notifications for
  /// 
  /// Returns a list of [NotificationModel] objects.
  Future<List<NotificationModel>> getAllNotifications(dynamic userId) async {
    try {
      final db = await _db;
      
      print('🗄️  NotificationRepository: Querying notifications for userId=$userId');
      
      // Query all notifications for this user, ordered by newest first
      final List<Map<String, dynamic>> maps = await db.query(
        'notifications',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      print('🗄️  NotificationRepository: Found ${maps.length} notifications in database');
      for (var map in maps) {
        print('   - ID: ${map['id']}, Type: ${map['type']}, UserId: ${map['user_id']}');
      }

      // Convert database maps to NotificationModel objects
      return List.generate(maps.length, (i) {
        return NotificationModel.fromMap(maps[i]);
      });
    } catch (e) {
      // Log error and rethrow for cubit to handle
      print('Error fetching all notifications: $e');
      rethrow;
    }
  }

  /// Fetch only unread notifications for a specific user.
  /// 
  /// Useful for showing notification badges or filtering.
  /// 
  /// [userId] - The id of the user to fetch notifications for
  /// 
  /// Returns a list of unread [NotificationModel] objects.
  Future<List<NotificationModel>> getUnreadNotifications(dynamic userId) async {
    try {
      final db = await _db;
      
      // Query unread notifications (is_read = 0)
      final List<Map<String, dynamic>> maps = await db.query(
        'notifications',
        where: 'user_id = ? AND is_read = ?',
        whereArgs: [userId, 0],
        orderBy: 'created_at DESC',
      );

      // Convert to NotificationModel objects
      return List.generate(maps.length, (i) {
        return NotificationModel.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching unread notifications: $e');
      rethrow;
    }
  }

  /// Mark a single notification as read.
  /// 
  /// Updates the is_read field to 1 (true) for the specified notification.
  /// This is typically called when the user taps on a notification.
  /// 
  /// [notificationId] - The id of the notification to mark as read
  /// 
  /// Returns the number of rows affected (should be 1 on success).
  Future<void> markAsRead(dynamic notificationId) async {
    try {
      final db = await _db;
      
      // Update is_read to 1 (true)
      final updatedRows = await db.update(
        'notifications',
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [notificationId],
      );

      print('Successfully marked notification $notificationId as read');
      // The instruction changed the return type to void, so we don't return updatedRows.
      // If the original return type was desired, this would be `return updatedRows;`
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  /// Mark all notifications as read for a specific user.
  /// 
  /// Updates is_read to 1 for all notifications belonging to the user.
  /// Useful for "mark all as read" functionality.
  /// 
  /// [userId] - The id of the user
  /// 
  /// Returns the number of rows affected.
  Future<int> markAllAsRead(dynamic userId) async {
    try {
      final db = await _db;
      
      // Update all unread notifications for this user
      final updatedRows = await db.update(
        'notifications',
        {'is_read': 1},
        where: 'user_id = ? AND is_read = ?',
        whereArgs: [userId, 0],
      );

      print('Successfully marked all notifications as read for user $userId');
      return updatedRows;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      rethrow;
    }
  }

  /// Insert a new notification into the database.
  /// 
  /// Creates a new notification for a user. This is typically called
  /// when an event happens that the user should be notified about
  /// (e.g., someone found their lost item, admin approved their post).
  /// 
  /// [notification] - The NotificationModel to insert (id should be null)
  /// 
  /// Returns the id of the newly inserted notification.
  Future<dynamic> insertNotification(NotificationModel notification) async {
    try {
      final db = await _db;
      
      // Insert and return the new row id
      final id = await db.insert(
        'notifications',
        notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('Successfully inserted notification with id: $id');
      return id;
    } catch (e) {
      print('Error inserting notification: $e');
      rethrow;
    }
  }

  /// Get the count of unread notifications for a user.
  /// 
  /// Useful for displaying notification badges.
  /// 
  /// [userId] - The id of the user
  /// 
  /// Returns the count of unread notifications.
  Future<int> getUnreadCount(dynamic userId) async {
    try {
      final db = await _db;
      
      // Count unread notifications
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND is_read = 0',
        [userId],
      );

      return result.first['count'] as int? ?? 0;
    } catch (e) {
      print('Error getting unread count: $e');
      rethrow;
    }
  }

  /// Get notifications by type for a user.
  /// 
  /// Allows filtering notifications by type (e.g., 'found_match', 'post_approved').
  /// 
  /// [userId] - The id of the user
  /// [type] - The notification type to filter by
  /// 
  /// Returns a list of [NotificationModel] objects of the specified type.
  Future<List<NotificationModel>> getNotificationsByType(
    dynamic userId,
    String type,
  ) async {
    try {
      final db = await _db;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'notifications',
        where: 'user_id = ? AND type = ?',
        whereArgs: [userId, type],
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return NotificationModel.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching notifications by type: $e');
      rethrow;
    }
  }
}
