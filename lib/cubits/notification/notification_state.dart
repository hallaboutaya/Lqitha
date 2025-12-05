import '../../data/models/notification.dart';

/// Base sealed class for Notification states.
/// 
/// Using sealed class ensures all possible states are handled in the UI.
/// This is the recommended pattern for BLoC/Cubit state management.
sealed class NotificationState {}

/// Initial state when the cubit is first created.
/// 
/// This is the default state before any data is loaded.
class NotificationInitial extends NotificationState {}

/// Loading state while fetching data from the database.
/// 
/// UI should show a loading indicator during this state.
class NotificationLoading extends NotificationState {}

/// Loaded state when data has been successfully fetched.
/// 
/// Contains the list of notifications to display in the UI.
/// Also includes count of unread notifications for badge display.
class NotificationLoaded extends NotificationState {
  /// List of notifications (all or filtered based on current view)
  final List<NotificationModel> notifications;

  /// Count of unread notifications (for badge display)
  final int unreadCount;

  /// Optional message to display
  final String? message;

  NotificationLoaded({
    required this.notifications,
    required this.unreadCount,
    this.message,
  });
}

/// Error state when something goes wrong.
/// 
/// Contains an error message to display to the user.
class NotificationError extends NotificationState {
  /// Error message describing what went wrong
  final String message;

  NotificationError(this.message);
}

/// Success state for operations like marking as read.
/// 
/// This state is emitted after successful operations,
/// then automatically transitions back to loading the updated list.
class NotificationSuccess extends NotificationState {
  /// Success message to display to the user
  final String message;

  NotificationSuccess(this.message);
}
