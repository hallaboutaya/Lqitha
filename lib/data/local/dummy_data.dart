import '../models/lost_post.dart';
import '../models/found_post.dart';

class DummyData {
  static List<LostPost> getPendingLostPosts() {
    return [
      LostPost(
        id: 1,
        photo:
            'https://images.unsplash.com/photo-1611843467160-25afb8df1074?w=400',
        description: 'Lost my silver iPhone 13 with a clear case.',
        status: 'pending',
        location: 'Bab Ezzouar Mall',
        category: 'Phone',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 15))
            .toIso8601String(),
        userId: 2,
        username: 'Karim Meziane',
        userPhoto: null,
      ),
    ];
  }

  static List<FoundPost> getPendingFoundPosts() {
    return [
      FoundPost(
        id: 1,
        photo:
            'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400',
        description: 'Found a black leather wallet near the metro station.',
        status: 'pending',
        location: 'Algiers Metro',
        category: 'Wallet',
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 2))
            .toIso8601String(),
        userId: 1,
        username: 'Sarah Johnson',
        userPhoto: null,
      ),
      FoundPost(
        id: 3,
        photo:
            'https://images.unsplash.com/photo-1553356084-58ef4a67b2a7?w=400',
        description: 'Blue backpack found at the coffee shop.',
        status: 'pending',
        location: 'Café Central',
        category: 'Backpack',
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
        userId: 3,
        username: 'Ahmed Benali',
        userPhoto: null,
      ),
    ];
  }

  static Map<String, int> getStatistics() {
    return {
      'totalPosts': 247,
      'pendingReview': 3,
      'approvedToday': 18,
      'totalIncome': 1525,
    };
  }
}
