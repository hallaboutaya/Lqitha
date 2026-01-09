import '../models/point_transaction.dart';
import '../../services/api_client.dart';

class RewardsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<PointTransaction>> getTransactions(String userId, {int limit = 50}) async {
    try {
      final response = await _apiClient.get(
        '/rewards/transactions',
        queryParams: {
          'user_id': userId,
          'limit': limit.toString(),
        },
      );

      if (response['success'] == true) {
        final List transactions = response['transactions'] ?? [];
        return transactions.map((t) => PointTransaction.fromMap(t)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        '/rewards/leaderboard',
        queryParams: {'limit': limit.toString()},
      );

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['leaderboard'] ?? []);
      }
      return [];
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }
}
