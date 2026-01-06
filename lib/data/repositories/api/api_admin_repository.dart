import '../../models/found_post.dart';
import '../../models/lost_post.dart';
import '../admin_repository.dart';
import 'api_found_repository.dart';
import 'api_lost_repository.dart';

/// API implementation of AdminRepository.
/// 
/// Delegates to API Found and Lost repositories for post management.
/// Extends AdminRepository for seamless switching.
class ApiAdminRepository extends AdminRepository {
  final ApiFoundRepository _foundRepository = ApiFoundRepository();
  final ApiLostRepository _lostRepository = ApiLostRepository();

  // ==================== FOUND POSTS ADMIN METHODS ====================

  /// Get all found posts (all statuses) via API.
  Future<List<FoundPost>> getAllFoundPosts() async {
    return await _foundRepository.getAllPosts();
  }

  /// Get found posts by status via API.
  Future<List<FoundPost>> getFoundPostsByStatus(String status) async {
    return await _foundRepository.getPostsByStatus(status);
  }

  /// Update found post status via API.
  Future<int> updateFoundPostStatus(dynamic postId, String status) async {
    return await _foundRepository.updatePostStatus(postId, status);
  }

  /// Delete found post via API.
  Future<int> deleteFoundPost(dynamic postId) async {
    return await _foundRepository.deletePost(postId);
  }

  // ==================== LOST POSTS ADMIN METHODS ====================

  /// Get all lost posts (all statuses) via API.
  Future<List<LostPost>> getAllLostPosts() async {
    return await _lostRepository.getAllPosts();
  }

  /// Get lost posts by status via API.
  Future<List<LostPost>> getLostPostsByStatus(String status) async {
    return await _lostRepository.getPostsByStatus(status);
  }

  /// Update lost post status via API.
  Future<int> updateLostPostStatus(dynamic postId, String status) async {
    return await _lostRepository.updatePostStatus(postId, status);
  }

  /// Delete lost post via API.
  Future<int> deleteLostPost(dynamic postId) async {
    return await _lostRepository.deletePost(postId);
  }

  // ==================== STATISTICS METHODS ====================

  /// Get count of pending found posts via API.
  Future<int> getPendingFoundCount() async {
    final posts = await _foundRepository.getPostsByStatus('pending');
    return posts.length;
  }

  /// Get count of pending lost posts via API.
  Future<int> getPendingLostCount() async {
    final posts = await _lostRepository.getPostsByStatus('pending');
    return posts.length;
  }

  /// Get total count of pending posts (found + lost) via API.
  Future<int> getTotalPendingCount() async {
    final foundCount = await getPendingFoundCount();
    final lostCount = await getPendingLostCount();
    return foundCount + lostCount;
  }

  @override
  Future<List<LostPost>> getPendingLostPosts() async {
    return await _lostRepository.getPostsByStatus('pending');
  }

  @override
  Future<List<FoundPost>> getPendingFoundPosts() async {
    return await _foundRepository.getPostsByStatus('pending');
  }

  @override
  Future<List<LostPost>> getApprovedLostPosts() async {
    return await _lostRepository.getPostsByStatus('approved');
  }

  @override
  Future<List<FoundPost>> getApprovedFoundPosts() async {
    return await _foundRepository.getPostsByStatus('approved');
  }

  @override
  Future<List<LostPost>> getRejectedLostPosts() async {
    return await _lostRepository.getPostsByStatus('rejected');
  }

  @override
  Future<List<FoundPost>> getRejectedFoundPosts() async {
    return await _foundRepository.getPostsByStatus('rejected');
  }

  @override
  Future<void> approvePost(dynamic id, String type) async {
    if (type == 'lost') {
      await _lostRepository.updatePostStatus(id, 'approved');
    } else {
      await _foundRepository.updatePostStatus(id, 'approved');
    }
  }

  @override
  Future<void> rejectPost(dynamic id, String type) async {
    if (type == 'lost') {
      await _lostRepository.updatePostStatus(id, 'rejected');
    } else {
      await _foundRepository.updatePostStatus(id, 'rejected');
    }
  }

  @override
  Future<Map<String, int>> getStatistics() async {
    try {
      final response = await _foundRepository.getStatistics();
      return response;
    } catch (e) {
      print('Error fetching statistics via API, using fallback logic: $e');
      final pendingFound = await getPendingFoundCount();
      final pendingLost = await getPendingLostCount();
      return {
        'totalPosts': 0,
        'pendingPosts': pendingFound + pendingLost,
        'approvedToday': 0,
        'activeUsers': 0,
      };
    }
  }
}
