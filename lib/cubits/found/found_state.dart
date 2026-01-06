import '../../data/models/found_post.dart';

/// Base sealed class for Found Posts states.
/// 
/// Using sealed class ensures all possible states are handled in the UI.
/// This is the recommended pattern for BLoC/Cubit state management.
sealed class FoundState {}

/// Initial state when the cubit is first created.
/// 
/// This is the default state before any data is loaded.
class FoundInitial extends FoundState {}

/// Loading state while fetching data from the database.
/// 
/// UI should show a loading indicator during this state.
class FoundLoading extends FoundState {}

/// Loaded state when data has been successfully fetched.
/// 
/// Contains the list of approved found posts to display in the UI.
/// The list may be empty if there are no approved posts.
class FoundLoaded extends FoundState {
  /// List of approved found posts
  final List<FoundPost> posts;

  /// Optional message to display (e.g., "No posts found" or success messages)
  final String? message;
  
  /// IDs of posts that have been unlocked by the current user
  final Set<String> unlockedPostIds;

  FoundLoaded({
    required this.posts,
    this.message,
    this.unlockedPostIds = const {},
  });
  
  /// Helper to check if a post is unlocked
  bool isUnlocked(String postId) => unlockedPostIds.contains(postId);
  
  FoundLoaded copyWith({
    List<FoundPost>? posts,
    String? message,
    Set<String>? unlockedPostIds,
  }) {
    return FoundLoaded(
      posts: posts ?? this.posts,
      message: message ?? this.message,
      unlockedPostIds: unlockedPostIds ?? this.unlockedPostIds,
    );
  }
}

/// Error state when something goes wrong.
/// 
/// Contains an error message to display to the user.
class FoundError extends FoundState {
  /// Error message describing what went wrong
  final String message;

  FoundError(this.message);
}

/// Success state for operations like adding or updating posts.
/// 
/// This state is emitted after successful insert/update operations,
/// then automatically transitions back to loading the updated list.
class FoundSuccess extends FoundState {
  /// Success message to display to the user
  final String message;

  FoundSuccess(this.message);
}
