import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/lost_post.dart';
import '../../data/repositories/lost_repository.dart';
import '../../data/repositories/unlock_repository.dart';
import 'lost_state.dart';

/// Cubit for managing Lost Posts state.
/// 
/// This cubit handles all business logic for lost posts including:
/// - Loading approved posts from the database
/// - Searching/filtering posts
/// - Adding new posts (with pending status)
/// - Updating existing posts
/// 
/// The cubit works with LostRepository to interact with the database
/// and emits different states (Loading, Loaded, Error) that the UI responds to.
class LostCubit extends Cubit<LostState> {
  /// Repository instance for database operations
  final LostRepository _repository;
  final UnlockRepository _unlockRepository;

  /// Cache of all loaded posts for client-side filtering
  List<LostPost> _allPosts = [];

  /// Constructor initializes cubit with LostInitial state
  LostCubit(this._repository, this._unlockRepository) : super(LostInitial());

  /// Load all approved lost posts from the database.
  /// 
  /// This method:
  /// 1. Emits LostLoading state
  /// 2. Fetches approved posts from repository
  /// 3. Caches posts for filtering
  /// 4. Emits LostLoaded with the posts
  /// 5. Emits LostError if something goes wrong
  /// 
  /// Called when: 
  /// - Page is first opened
  /// - User pulls to refresh
  /// - After adding/updating a post
  Future<void> loadApprovedPosts() async {
    try {
      // Emit loading state to show loading indicator
      emit(LostLoading());

      // Fetch only approved posts from database
      final posts = await _repository.getApprovedPosts();
      
      // Fetch unlocked post IDs for the current user
      final unlocks = await _unlockRepository.getUserUnlocks();
      final unlockedIds = unlocks
          .where((u) => u.postType == 'lost')
          .map((u) => u.postId)
          .toSet();

      // Cache posts for client-side search/filter
      _allPosts = posts;

      // Emit loaded state with posts and unlock info
      emit(LostLoaded(
        posts: posts,
        unlockedPostIds: unlockedIds,
        message: posts.isEmpty ? 'No lost items yet' : null,
      ));
    } catch (e) {
      // Emit error state with user-friendly message
      emit(LostError('Failed to load lost items. Please try again.'));
      print('Error in loadApprovedPosts: $e');
    }
  }

  /// Search posts by query string.
  /// 
  /// Performs client-side filtering on the cached posts for instant results.
  /// Searches in description, location, and category fields.
  /// 
  /// [query] - Search term entered by user
  /// 
  /// If query is empty, shows all posts.
  /// Otherwise, filters posts and emits LostLoaded with filtered results.
  void searchPosts(String query) {
    try {
      // If query is empty, show all posts
      if (query.trim().isEmpty) {
        emit(LostLoaded(posts: _allPosts));
        return;
      }

      // Convert query to lowercase for case-insensitive search
      final lowerQuery = query.toLowerCase();

      // Filter posts client-side for instant results
      final filteredPosts = _allPosts.where((post) {
        final description = post.description?.toLowerCase() ?? '';
        final location = post.location?.toLowerCase() ?? '';
        final category = post.category?.toLowerCase() ?? '';

        // Check if query matches any field
        return description.contains(lowerQuery) ||
            location.contains(lowerQuery) ||
            category.contains(lowerQuery);
      }).toList();

      // Emit filtered results
      emit(LostLoaded(
        posts: filteredPosts,
        message: filteredPosts.isEmpty ? 'No items match your search' : null,
      ));
    } catch (e) {
      emit(LostError('Error searching posts'));
      print('Error in searchPosts: $e');
    }
  }

  /// Add a new lost post to the database.
  /// 
  /// The post will be created with status='pending' (database default).
  /// It will NOT appear in the feed until admin approves it.
  /// 
  /// [post] - The new LostPost to add (id should be null)
  /// 
  /// Flow:
  /// 1. Emit loading state
  /// 2. Insert post to database
  /// 3. Emit success message
  /// 4. Reload all posts (the new post won't appear yet - it's pending)
  Future<void> addPost(LostPost post) async {
    try {
      emit(LostLoading());

      // Insert post - it will have status='pending' by default
      await _repository.insertPost(post);

      // Emit success message
      emit(LostSuccess(
        'Your item has been submitted and is awaiting admin approval.',
      ));

      // Reload approved posts
      // Note: The newly added post won't appear here because it's pending
      await Future.delayed(const Duration(milliseconds: 500));
      await loadApprovedPosts();
    } catch (e) {
      emit(LostError('Failed to submit item. Please try again.'));
      print('Error in addPost: $e');
    }
  }

  /// Update an existing lost post.
  /// 
  /// Allows users to edit their post details.
  /// Status is not changed - that's admin's responsibility.
  /// 
  /// [post] - The updated LostPost (id must not be null)
  /// 
  /// Flow:
  /// 1. Emit loading state
  /// 2. Update post in database
  /// 3. Emit success message
  /// 4. Reload all posts to reflect changes
  Future<void> updatePost(LostPost post) async {
    try {
      emit(LostLoading());

      // Update post in database
      await _repository.updatePost(post);

      // Emit success message
      emit(LostSuccess('Item updated successfully!'));

      // Reload posts to show updated data
      await Future.delayed(const Duration(milliseconds: 500));
      await loadApprovedPosts();
    } catch (e) {
      emit(LostError('Failed to update item. Please try again.'));
      print('Error in updatePost: $e');
    }
  }

  /// Get posts for a specific user (for profile page).
  /// 
  /// This returns ALL posts by the user regardless of status,
  /// so they can see their pending/approved/rejected posts.
  /// 
  /// [userId] - The id of the user
  Future<void> loadUserPosts(int userId) async {
    try {
      emit(LostLoading());

      final posts = await _repository.getPostsByUser(userId);

      emit(LostLoaded(
        posts: posts,
        message: posts.isEmpty ? 'No posts yet' : null,
      ));
    } catch (e) {
      emit(LostError('Failed to load your posts.'));
      print('Error in loadUserPosts: $e');
    }
  }

  /// Refresh the posts list.
  Future<void> refresh() async {
    await loadApprovedPosts();
  }

  /// Mark a post as unlocked in the local state
  Future<void> unlockPost(String postId) async {
    if (state is LostLoaded) {
      final current = state as LostLoaded;
      try {
        final updatedUnlocks = Set<String>.from(current.unlockedPostIds)..add(postId);
        emit(current.copyWith(unlockedPostIds: updatedUnlocks));
      } catch (e) {
        print('Error unlocking lost post in cubit: $e');
      }
    }
  }
}
