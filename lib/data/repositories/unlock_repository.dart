import '../models/contact_unlock.dart';

abstract class UnlockRepository {
  /// Create a new unlock record for the current user and specified post.
  Future<ContactUnlock?> createUnlock(String postId, String postType);

  /// Get all unlock records for the current user.
  Future<List<ContactUnlock>> getUserUnlocks();

  /// Check if a specific post is unlocked for the current user.
  /// Note: Ideally we load all and check locally for performance, but this is for reference.
  Future<bool> isPostUnlocked(String postId, String postType);
}
