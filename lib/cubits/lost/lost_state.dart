import '../../data/models/lost_post.dart';

/// Base sealed class for Lost Posts states.
/// 
/// Using sealed class ensures all possible states are handled in the UI.
/// This is the recommended pattern for BLoC/Cubit state management.
sealed class LostState {}

/// Initial state when the cubit is first created.
/// 
/// This is the default state before any data is loaded.
class LostInitial extends LostState {}

/// Loading state while fetching data from the database.
/// 
/// UI should show a loading indicator during this state.
class LostLoading extends LostState {}

/// Loaded state when data has been successfully fetched.
/// 
/// Contains the list of approved lost posts to display in the UI.
/// The list may be empty if there are no approved posts.
class LostLoaded extends LostState {
  /// List of approved lost posts
  final List<LostPost> posts;

  /// Optional message to display (e.g., "No posts found" or success messages)
  final String? message;

  LostLoaded({
    required this.posts,
    this.message,
  });
}

/// Error state when something goes wrong.
/// 
/// Contains an error message to display to the user.
class LostError extends LostState {
  /// Error message describing what went wrong
  final String message;

  LostError(this.message);
}

/// Success state for operations like adding or updating posts.
/// 
/// This state is emitted after successful insert/update operations,
/// then automatically transitions back to loading the updated list.
class LostSuccess extends LostState {
  /// Success message to display to the user
  final String message;

  LostSuccess(this.message);
}
