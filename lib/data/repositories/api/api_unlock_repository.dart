import '../../../services/api_client.dart';
import '../../models/contact_unlock.dart';
import '../unlock_repository.dart';

class ApiUnlockRepository extends UnlockRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<ContactUnlock?> createUnlock(String postId, String postType) async {
    try {
      final response = await _apiClient.post(
        '/unlocks',
        body: {
          'post_id': postId,
          'post_type': postType,
        },
      );

      if (response['success'] == true) {
        return ContactUnlock.fromMap(response['unlock']);
      }
      return null;
    } catch (e) {
      print('Error creating unlock via API: $e');
      return null;
    }
  }

  @override
  Future<List<ContactUnlock>> getUserUnlocks() async {
    try {
      final response = await _apiClient.get('/unlocks');

      if (response['success'] == true) {
        final List<dynamic> unlocksJson = response['unlocks'] ?? [];
        return unlocksJson.map((json) => ContactUnlock.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching user unlocks via API: $e');
      return [];
    }
  }

  @override
  Future<bool> isPostUnlocked(String postId, String postType) async {
    // For individual checks, we can just fetch all and check, 
    // or the backend could provide a specific endpoint.
    // For now, let's assume we load all in the Cubit.
    final unlocks = await getUserUnlocks();
    return unlocks.any((u) => u.postId == postId && u.postType == postType);
  }
}
