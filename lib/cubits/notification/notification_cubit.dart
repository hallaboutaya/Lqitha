import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/notification.dart';
import '../../data/repositories/notification_repository.dart';
import 'notification_state.dart';

/// Cubit for managing Notification state.
/// 
/// This cubit handles all business logic for notifications including:
/// - Loading all notifications for a user
/// - Loading only unread notifications
/// - Marking notifications as read (single or all)
/// - Filtering notifications by type
/// - Getting unread count for badges
/// 
/// The cubit works with NotificationRepository to interact with the database
/// and emits different states (Loading, Loaded, Error) that the UI responds to.
class NotificationCubit extends Cubit<NotificationState> {
  /// Repository instance for database operations
  final NotificationRepository _repository;

  /// Cache of all loaded notifications for filtering
  List<NotificationModel> _allNotifications = [];

  /// Current filter mode ('all', 'unread', or specific type)
  String _currentFilter = 'all';

  /// Constructor initializes cubit with NotificationInitial state
  NotificationCubit(this._repository) : super(NotificationInitial());

  /// Load all notifications for a specific user.
  /// 
  /// This method:
  /// 1. Emits NotificationLoading state
  /// 2. Fetches all notifications from repository
  /// 3. Gets unread count for badge
  /// 4. Caches notifications for filtering
  /// 5. Emits NotificationLoaded with notifications and unread count
  /// 6. Emits NotificationError if something goes wrong
  /// 
  /// [userId] - The id of the current user
  /// 
  /// Called when: 
  /// - Page is first opened
  /// - User pulls to refresh
  /// - After marking notifications as read
  Future<void> loadAllNotifications(int userId) async {
    try {
      // Emit loading state to show loading indicator
      emit(NotificationLoading());

      // Fetch all notifications for this user
      final notifications = await _repository.getAllNotifications(userId);

      // Get unread count for badge
      final unreadCount = await _repository.getUnreadCount(userId);

      // Cache notifications for filtering
      _allNotifications = notifications;
      _currentFilter = 'all';

      // Emit loaded state with notifications and unread count
      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
        message: notifications.isEmpty ? 'No notifications yet' : null,
      ));
    } catch (e) {
      // Emit error state with user-friendly message
      emit(NotificationError('Failed to load notifications. Please try again.'));
      print('Error in loadAllNotifications: $e');
    }
  }

  /// Load only unread notifications for a user.
  /// 
  /// Shows only notifications where is_read = false.
  /// Useful for a "unread only" filter view.
  /// 
  /// [userId] - The id of the current user
  Future<void> loadUnreadNotifications(int userId) async {
    try {
      emit(NotificationLoading());

      // Fetch only unread notifications
      final notifications = await _repository.getUnreadNotifications(userId);

      // Get unread count (should match notifications length)
      final unreadCount = notifications.length;

      // Cache and update filter
      _allNotifications = notifications;
      _currentFilter = 'unread';

      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
        message: notifications.isEmpty ? 'No unread notifications' : null,
      ));
    } catch (e) {
      emit(NotificationError('Failed to load unread notifications.'));
      print('Error in loadUnreadNotifications: $e');
    }
  }

  /// Mark a single notification as read.
  /// 
  /// Updates the is_read field to true for the specified notification.
  /// This is typically called when user taps on a notification.
  /// 
  /// [notificationId] - The id of the notification to mark as read
  /// [userId] - The id of the current user (to reload notifications)
  /// 
  /// Flow:
  /// 1. Update notification in database
  /// 2. Reload notifications to reflect the change
  Future<void> markAsRead(int notificationId, int userId) async {
    try {
      // Mark as read in database
      await _repository.markAsRead(notificationId);

      // Reload notifications to reflect the change
      // Use the current filter mode
      if (_currentFilter == 'unread') {
        await loadUnreadNotifications(userId);
      } else {
        await loadAllNotifications(userId);
      }
    } catch (e) {
      emit(NotificationError('Failed to mark notification as read.'));
      print('Error in markAsRead: $e');
    }
  }

  /// Mark all notifications as read for a user.
  /// 
  /// Updates is_read to true for all unread notifications.
  /// Useful for "mark all as read" button.
  /// 
  /// [userId] - The id of the current user
  /// 
  /// Flow:
  /// 1. Emit success message
  /// 2. Update all notifications in database
  /// 3. Reload notifications
  Future<void> markAllAsRead(int userId) async {
    try {
      // Mark all as read in database
      final updatedCount = await _repository.markAllAsRead(userId);

      // Show success message if any were updated
      if (updatedCount > 0) {
        emit(NotificationSuccess('All notifications marked as read!'));
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Reload notifications
      await loadAllNotifications(userId);
    } catch (e) {
      emit(NotificationError('Failed to mark all as read.'));
      print('Error in markAllAsRead: $e');
    }
  }

  /// Filter notifications by type.
  /// 
  /// Performs client-side filtering on cached notifications for instant results.
  /// If no cached data exists, fetches from database.
  /// 
  /// [userId] - The id of the current user
  /// [type] - The notification type to filter by (e.g., 'found_match')
  Future<void> filterByType(int userId, String type) async {
    try {
      // If we have cached data, filter client-side for instant results
      if (_allNotifications.isNotEmpty && _currentFilter == 'all') {
        final filtered = _allNotifications.where((n) => n.type == type).toList();
        
        final unreadCount = await _repository.getUnreadCount(userId);
        
        emit(NotificationLoaded(
          notifications: filtered,
          unreadCount: unreadCount,
          message: filtered.isEmpty ? 'No notifications of this type' : null,
        ));
        return;
      }

      // Otherwise fetch from database
      emit(NotificationLoading());

      final notifications = await _repository.getNotificationsByType(userId, type);
      final unreadCount = await _repository.getUnreadCount(userId);

      _currentFilter = type;

      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
        message: notifications.isEmpty ? 'No notifications of this type' : null,
      ));
    } catch (e) {
      emit(NotificationError('Failed to filter notifications.'));
      print('Error in filterByType: $e');
    }
  }

  /// Get count of unread notifications.
  /// 
  /// Returns just the count without loading all notifications.
  /// Useful for displaying notification badges in navigation bar.
  /// 
  /// [userId] - The id of the current user
  /// 
  /// Returns the count of unread notifications.
  Future<int> getUnreadCount(int userId) async {
    try {
      return await _repository.getUnreadCount(userId);
    } catch (e) {
      print('Error in getUnreadCount: $e');
      return 0;
    }
  }

  /// Create a new notification.
  /// 
  /// This is typically called by the system when an event occurs
  /// that the user should be notified about.
  /// 
  /// [notification] - The NotificationModel to create
  /// [userId] - The id of the user to reload notifications for
  /// 
  /// Note: This is for internal use. In a real app, notifications
  /// would likely be created server-side or by background processes.
  Future<void> createNotification(
    NotificationModel notification,
    int userId,
  ) async {
    try {
      await _repository.insertNotification(notification);

      // Reload notifications to show the new one
      await loadAllNotifications(userId);
    } catch (e) {
      print('Error in createNotification: $e');
    }
  }

  /// Refresh the notifications list.
  /// 
  /// Convenience method that reloads based on current filter.
  /// Can be connected to pull-to-refresh UI.
  /// 
  /// [userId] - The id of the current user
  Future<void> refresh(int userId) async {
    if (_currentFilter == 'unread') {
      await loadUnreadNotifications(userId);
    } else {
      await loadAllNotifications(userId);
    }
  }
}
