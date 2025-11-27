// lib/services/dummy_service.dart
import '../models/post.dart';

class DummyService {
  static List<Post> getDummyPosts() {
    return [
      // Pending posts (3)
      Post(
        id: '1',
        userName: 'Sarah Johnson',
        userImage: 'https://i.pravatar.cc/150?img=1',
        timestamp: '2 min ago',
        type: 'Lost',
        description: 'Found a black leather wallet near the metro station.',
        location: 'Algiers Metro',
        categories: ['Wallet', 'Cards'],
        imageUrl:
            'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400',
        status: 'pending',
      ),
      Post(
        id: '2',
        userName: 'Karim Meziane',
        userImage: 'https://i.pravatar.cc/150?img=33',
        timestamp: '15 min ago',
        type: 'Lost',
        description: 'Lost my silver iPhone 13 with a clear case.',
        location: 'Bab Ezzouar Mall',
        categories: ['Phone', 'Electronics'],
        imageUrl:
            'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=400',
        status: 'pending',
      ),
      Post(
        id: '3',
        userName: 'Ahmed Benali',
        userImage: 'https://i.pravatar.cc/150?img=12',
        timestamp: '1 hour ago',
        type: 'Found',
        description: 'Blue backpack found at the coffee shop.',
        location: 'Café Central',
        categories: ['Backpack'],
        imageUrl:
            'https://images.unsplash.com/photo-1511447333015-45b65e60f6d5?w=400',
        status: 'pending',
      ),
      // Approved posts (2)
      Post(
        id: '4',
        userName: 'Fatima Khelif',
        userImage: 'https://i.pravatar.cc/150?img=5',
        timestamp: '3 hours ago',
        type: 'Lost',
        description: 'Lost my car keys with a red keychain.',
        location: 'Hussein Dey',
        categories: ['Keys', 'Personal'],
        imageUrl:
            'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=400',
        status: 'approved',
      ),
      Post(
        id: '5',
        userName: 'Yacine Brahimi',
        userImage: 'https://i.pravatar.cc/150?img=8',
        timestamp: '5 hours ago',
        type: 'Found',
        description: 'Found a brown leather bag at the bus station.',
        location: 'Tafourah Station',
        categories: ['Bag', 'Leather'],
        imageUrl:
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
        status: 'approved',
      ),
      // Rejected post (1)
      Post(
        id: '6',
        userName: 'Nadia Boudiaf',
        userImage: 'https://i.pravatar.cc/150?img=9',
        timestamp: '1 day ago',
        type: 'Lost',
        description: 'Lost my prescription glasses in a black case.',
        location: 'University Campus',
        categories: ['Glasses', 'Personal'],
        imageUrl:
            'https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=400',
        status: 'rejected',
      ),
    ];
  }
}
