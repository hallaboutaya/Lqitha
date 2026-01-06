import 'package:sqflite/sqflite.dart';
import '../data/databases/db_helper.dart';

/// Database seeder to populate test data for development and testing.
/// 
/// This service inserts sample users, found posts, lost posts, and notifications
/// into the database so you can test the app functionality.
class DatabaseSeeder {
  /// Seed the database with test data.
  /// 
  /// This will:
  /// 1. Check if database already has data
  /// 2. If empty, create test users, posts, and notifications
  /// 3. If not empty, skip seeding to preserve user data
  /// 
  /// Returns true if seeding was successful or skipped, false on error.
  static Future<bool> seedDatabase() async {
    try {
      final db = await DBHelper.getDatabase();
      
      // Check if database already has users
      final userCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM users')
      ) ?? 0;
      
      if (userCount > 0) {
        print('📊 Database already has $userCount users, skipping seed');
        return true;
      }
      
      print('🌱 Database is empty, seeding with test data...');
      
      // Start a transaction for atomicity
      await db.transaction((txn) async {
        // 1. Insert Users
        final users = await _insertUsers(txn);
        
        // 2. Insert Found Posts
        await _insertFoundPosts(txn, users);
        
        // 3. Insert Lost Posts
        await _insertLostPosts(txn, users);
        
        // 4. Insert Notifications
        await _insertNotifications(txn, users);
      });
      
      print('✅ Database seeded successfully!');
      return true;
    } catch (e) {
      print('❌ Error seeding database: $e');
      return false;
    }
  }
  
  /// Insert test users
  static Future<List<Map<String, dynamic>>> _insertUsers(Transaction txn) async {
    final now = DateTime.now().toIso8601String();
    
    final users = [
      {
        'username': 'Sarah Johnson',
        'email': 'sarah@example.com',
        'password': 'password123',
        'phone_number': '+213 555 1234',
        'photo': 'https://i.pravatar.cc/150?img=1',
        'role': 'user',
        'points': 150,
        'created_at': now,
        'updated_at': now,
      },
      {
        'username': 'Ahmed Benali',
        'email': 'ahmed@example.com',
        'password': 'password123',
        'phone_number': '+213 555 5678',
        'photo': 'https://i.pravatar.cc/150?img=33',
        'role': 'user',
        'points': 200,
        'created_at': now,
        'updated_at': now,
      },
      {
        'username': 'Karim Meziane',
        'email': 'karim@example.com',
        'password': 'password123',
        'phone_number': '+213 555 9012',
        'photo': 'https://i.pravatar.cc/150?img=12',
        'role': 'user',
        'points': 75,
        'created_at': now,
        'updated_at': now,
      },
      {
        'username': 'Amina Kader',
        'email': 'amina@example.com',
        'password': 'password123',
        'phone_number': '+213 555 3456',
        'photo': 'https://i.pravatar.cc/150?img=5',
        'role': 'user',
        'points': 300,
        'created_at': now,
        'updated_at': now,
      },
      {
        'username': 'Admin User',
        'email': 'admin@lqitha.com',
        'password': 'admin123',
        'phone_number': '+213 555 0000',
        'photo': 'https://i.pravatar.cc/150?img=8',
        'role': 'admin',
        'points': 0,
        'created_at': now,
        'updated_at': now,
      },
    ];
    
    final insertedUsers = <Map<String, dynamic>>[];
    for (final user in users) {
      final id = await txn.insert('users', user);
      insertedUsers.add({...user, 'id': id});
      print('👤 Inserted user: ${user['username']} with id=$id');
    }
    
    print('👥 Inserted ${insertedUsers.length} users');
    return insertedUsers;
  }
  
  /// Insert found posts
  static Future<void> _insertFoundPosts(
    Transaction txn,
    List<Map<String, dynamic>> users,
  ) async {
    final userId1 = users[0]['id'] as int;
    final userId2 = users[1]['id'] as int;
    final userId3 = users[2]['id'] as int;
    
    final now = DateTime.now();
    
    final foundPosts = [
      {
        'photo': 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400',
        'description': 'Found a black leather wallet near the metro station. Contains some cards and cash.',
        'status': 'approved',
        'location': 'Algiers Metro',
        'category': 'Wallet',
        'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'user_id': userId1,
      },
      {
        'photo': 'https://images.unsplash.com/photo-1511447333015-45b65e60f6d5?w=400',
        'description': 'Blue backpack found at the coffee shop. Contains books and a laptop.',
        'status': 'approved',
        'location': 'Café Central',
        'category': 'Backpack',
        'created_at': now.subtract(const Duration(hours: 5)).toIso8601String(),
        'user_id': userId2,
      },
      {
        'photo': 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=400',
        'description': 'Set of keys with a red keychain found at the university parking lot.',
        'status': 'pending',
        'location': 'University Campus',
        'category': 'Keys',
        'created_at': now.subtract(const Duration(minutes: 30)).toIso8601String(),
        'user_id': userId3,
      },
      {
        'photo': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
        'description': 'Brown leather bag found at the bus station. Please contact if this is yours.',
        'status': 'approved',
        'location': 'Tafourah Station',
        'category': 'Bag',
        'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
        'user_id': userId1,
      },
    ];
    
    for (final post in foundPosts) {
      await txn.insert('found_posts', post);
    }
    
    print('📦 Inserted ${foundPosts.length} found posts');
  }
  
  /// Insert lost posts
  static Future<void> _insertLostPosts(
    Transaction txn,
    List<Map<String, dynamic>> users,
  ) async {
    final userId1 = users[0]['id'] as int;
    final userId2 = users[1]['id'] as int;
    final userId3 = users[2]['id'] as int;
    
    final now = DateTime.now();
    
    final lostPosts = [
      {
        'photo': 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=400',
        'description': 'Lost my brown leather wallet with ID cards and bank cards. Last seen at the shopping mall.',
        'status': 'approved',
        'location': 'Bab Ezzouar Mall',
        'category': 'Wallet',
        'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
        'user_id': userId1,
      },
      {
        'photo': 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=400',
        'description': 'Silver iPhone 13 with a clear case. Lost at the beach yesterday afternoon.',
        'status': 'approved',
        'location': 'Sidi Fredj Beach',
        'category': 'Phone',
        'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
        'user_id': userId2,
      },
      {
        'photo': 'https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=400',
        'description': 'Lost my prescription glasses in a black case. Very important, I can barely see without them!',
        'status': 'pending',
        'location': 'Grande Poste',
        'category': 'Glasses',
        'created_at': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'user_id': userId3,
      },
      {
        'photo': 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=400',
        'description': 'Lost my car keys with a red keychain. Reward offered for return!',
        'status': 'approved',
        'location': 'Hussein Dey',
        'category': 'Keys',
        'created_at': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'user_id': userId1,
      },
    ];
    
    for (final post in lostPosts) {
      await txn.insert('lost_posts', post);
    }
    
    print('🔍 Inserted ${lostPosts.length} lost posts');
  }
  
  /// Insert notifications
  static Future<void> _insertNotifications(
    Transaction txn,
    List<Map<String, dynamic>> users,
  ) async {
    final userId1 = users[0]['id'] as int;
    final userId2 = users[1]['id'] as int;
    
    final now = DateTime.now();
    
    final notifications = [
      {
        'title': 'Item Found Match',
        'message': 'Ahmed Benali says they found your lost wallet!',
        'related_post_id': 1,
        'type': 'found_match',
        'is_read': 0,
        'created_at': now.subtract(const Duration(minutes: 5)).toIso8601String(),
        'user_id': userId1,
      },
      {
        'title': 'Contact Unlocked',
        'message': 'Sarah Johnson unlocked your contact information',
        'related_post_id': 2,
        'type': 'contact_unlocked',
        'is_read': 0,
        'created_at': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'user_id': userId1,
      },
      {
        'title': 'Post Approved',
        'message': 'Your found item post has been approved and is now visible to users',
        'related_post_id': 1,
        'type': 'post_approved',
        'is_read': 1,
        'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'user_id': userId2,
      },
      {
        'title': 'Item Found Match',
        'message': 'Karim Meziane says they found your phone!',
        'related_post_id': 2,
        'type': 'found_match',
        'is_read': 0,
        'created_at': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'user_id': userId2,
      },
    ];
    
    for (final notification in notifications) {
      await txn.insert('notifications', notification);
    }
    
    print('🔔 Inserted ${notifications.length} notifications');
  }
  
  /// Clear all data from database (useful for resetting)
  static Future<void> clearAllData() async {
    try {
      final db = await DBHelper.getDatabase();
      await db.transaction((txn) async {
        await txn.delete('notifications');
        await txn.delete('found_posts');
        await txn.delete('lost_posts');
        await txn.delete('users');
      });
      print('🗑️  All data cleared from database');
    } catch (e) {
      print('❌ Error clearing database: $e');
    }
  }
}

