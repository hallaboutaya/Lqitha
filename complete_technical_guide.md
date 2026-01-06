# Lqitha App - Complete Technical Documentation
## Everything You Need to Know for the Demo

---

## TABLE OF CONTENTS
1. [Database Architecture](#1-database-architecture)
2. [Database Seeder - How It Works](#2-database-seeder---how-it-works)
3. [Repository Pattern](#3-repository-pattern)
4. [Cubit State Management](#4-cubit-state-management)
5. [Authentication System](#5-authentication-system)
6. [Page-by-Page Breakdown](#6-page-by-page-breakdown)
7. [Data Flow Examples](#7-data-flow-examples)
8. [Expected Questions & Answers](#8-expected-questions--answers)

---

## 1. DATABASE ARCHITECTURE

### 1.1 Database Setup (`lib/data/databases/db_helper.dart`)

**Database Name:** `lqitha.db`  
**Database Version:** `2`  
**Location:** Device's app data directory (persistent storage)

**Key Methods:**
```dart
static Future<Database> getDatabase() async {
  if (_database != null) return _database!; // Singleton pattern
  
  _database = await openDatabase(
    join(await getDatabasesPath(), 'lqitha.db'),
    version: 2,
    onCreate: (db, version) async {
      await _createTables(db); // Create all 4 tables
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      // Handle schema changes
      if (oldVersion < 2) {
        await db.execute('DROP TABLE IF EXISTS notifications');
        // ... drop all tables and recreate
        await _createTables(db);
      }
    },
  );
  return _database!;
}
```

**Why Singleton?**
- Only ONE database connection for the entire app
- Prevents multiple connections and data corruption
- Efficient resource usage

---

### 1.2 Database Schema (4 Tables)

#### **Table 1: `users`**
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,           -- UNIQUE constraint prevents duplicate emails
  password TEXT NOT NULL,
  phone_number TEXT,
  photo TEXT,                           -- URL to avatar image
  role TEXT DEFAULT 'user',             -- 'user' or 'admin'
  points INTEGER DEFAULT 0,             -- Gamification points
  created_at TEXT,                      -- ISO 8601 timestamp
  updated_at TEXT
)
```

**Purpose:** Store user accounts  
**Key Fields:**
- `email UNIQUE` - Prevents duplicate accounts
- `role` - Differentiates users from admins
- `points` - Gamification system

#### **Table 2: `found_posts`**
```sql
CREATE TABLE found_posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  photo TEXT,                           -- URL to item image
  description TEXT,
  status TEXT DEFAULT 'pending',        -- 'pending', 'approved', 'rejected'
  location TEXT,
  category TEXT,                        -- 'wallet', 'keys', 'phone', etc.
  created_at TEXT,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)
```

**Purpose:** Store items people have found  
**Key Fields:**
- `status` - Admin approval workflow (pending → approved/rejected)
- `user_id` - Links to the user who found the item
- `ON DELETE CASCADE` - If user deleted, their posts are also deleted

#### **Table 3: `lost_posts`**
```sql
CREATE TABLE lost_posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  photo TEXT,
  description TEXT,
  status TEXT DEFAULT 'pending',
  location TEXT,
  category TEXT,
  created_at TEXT,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)
```

**Purpose:** Store items people are looking for  
**Identical structure to `found_posts`** for consistency

#### **Table 4: `notifications`**
```sql
CREATE TABLE notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  related_post_id INTEGER,              -- Links to found/lost post
  type TEXT,                            -- 'item_found', 'post_approved', 'contact_unlocked'
  is_read INTEGER DEFAULT 0,            -- 0 = unread, 1 = read (SQLite doesn't have boolean)
  created_at TEXT,
  user_id INTEGER,                      -- Recipient of notification
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)
```

**Purpose:** Store user notifications  
**Key Fields:**
- `type` - Categorizes notification for different actions
- `is_read` - Track read/unread status
- `related_post_id` - Links notification to relevant post

---

### 1.3 Foreign Key Relationships

```
users (id)
  ↓ ONE-TO-MANY
  ├─→ found_posts (user_id)
  ├─→ lost_posts (user_id)
  └─→ notifications (user_id)
```

**What this means:**
- One user can have many found posts
- One user can have many lost posts
- One user can have many notifications
- If user is deleted, ALL their data is deleted (CASCADE)

---

## 2. DATABASE SEEDER - HOW IT WORKS

### 2.1 Seeder Logic (`lib/services/database_seeder.dart`)

**Called from:** `main.dart` on app startup

```dart
static Future<bool> seedDatabase() async {
  final db = await DBHelper.getDatabase();
  
  // STEP 1: Check if database already has data
  final userCount = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM users')
  ) ?? 0;
  
  // STEP 2: If data exists, SKIP seeding (preserve user data)
  if (userCount > 0) {
    print('📊 Database already has $userCount users, skipping seed');
    return true;  // EXIT - Don't seed!
  }
  
  // STEP 3: Database is empty, seed with test data
  print('🌱 Database is empty, seeding with test data...');
  
  await db.transaction((txn) async {
    final users = await _insertUsers(txn);        // Insert 5 test users
    await _insertFoundPosts(txn, users);          // Insert 4 found posts
    await _insertLostPosts(txn, users);           // Insert 4 lost posts
    await _insertNotifications(txn, users);       // Insert 4 notifications
  });
  
  return true;
}
```

---

### 2.2 When Does Seeding Happen?

| Scenario | Seeding Behavior |
|----------|------------------|
| **First app launch** | ✅ Seeds database with test data |
| **Hot reload (`r`)** | ❌ No seeding (database untouched) |
| **Hot restart (`R`)** | ❌ No seeding (database preserved) |
| **Stop & `flutter run`** | ❌ No seeding (database preserved) |
| **Uninstall & reinstall** | ✅ Seeds again (database deleted) |
| **`flutter clean`** | ✅ May seed again (clears cache) |

**Key Point:** Once you create an account or post, it **persists across app restarts**!

---

### 2.3 What Data Gets Seeded?

#### **5 Test Users:**
1. **Sarah Johnson** (`sarah@example.com` / `password123`) - 150 points
2. **Ahmed Benali** (`ahmed@example.com` / `password123`) - 200 points
3. **Karim Meziane** (`karim@example.com` / `password123`) - 75 points
4. **Amina Kader** (`amina@example.com` / `password123`) - 100 points
5. **Admin User** (`admin@lqitha.com` / `admin123`) - Role: `admin`

#### **4 Found Posts:**
- Wallet found by Sarah
- Phone found by Ahmed
- Keys found by Karim
- Laptop found by Amina

All with `status = 'approved'` (already approved by admin)

#### **4 Lost Posts:**
- Student ID lost by Sarah
- Backpack lost by Ahmed
- Headphones lost by Karim
- Watch lost by Amina

All with `status = 'approved'`

#### **4 Notifications:**
- 2 for Sarah (item found, contact unlocked)
- 2 for Ahmed (post approved, item found)

---

### 2.4 Why Use Transactions?

```dart
await db.transaction((txn) async {
  await _insertUsers(txn);
  await _insertFoundPosts(txn, users);
  await _insertLostPosts(txn, users);
  await _insertNotifications(txn, users);
});
```

**Benefits:**
- **Atomicity:** Either ALL inserts succeed or NONE do
- **No partial data:** Prevents corrupted database state
- **Rollback on error:** If one insert fails, everything rolls back

---

## 3. REPOSITORY PATTERN

### 3.1 What is a Repository?

**Repository** = A class that handles ALL database operations for ONE table

**Purpose:**
- Abstracts database queries from business logic
- Centralizes data access
- Makes code testable (can mock repositories)
- Type-safe conversions (Map ↔ Model)

---

### 3.2 Repository Structure

```
lib/data/repositories/
├── user_repository.dart           # Users table operations
├── found_repository.dart          # Found posts table operations
├── lost_repository.dart           # Lost posts table operations
└── notification_repository.dart   # Notifications table operations
```

---

### 3.3 Example: `FoundRepository`

```dart
class FoundRepository {
  Future<Database> get _db async => await DBHelper.getDatabase();

  // GET all approved found posts
  Future<List<FoundPost>> getApprovedPosts() async {
    final db = await _db;
    final maps = await db.query(
      'found_posts',
      where: 'status = ?',
      whereArgs: ['approved'],
      orderBy: 'created_at DESC',
    );
    return maps.map((m) => FoundPost.fromMap(m)).toList();
  }

  // GET found post by ID
  Future<FoundPost?> getPostById(int id) async {
    final db = await _db;
    final maps = await db.query(
      'found_posts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return FoundPost.fromMap(maps.first);
  }

  // INSERT new found post
  Future<int> insertPost(FoundPost post) async {
    final db = await _db;
    return await db.insert('found_posts', post.toMap());
  }

  // UPDATE found post
  Future<int> updatePost(FoundPost post) async {
    final db = await _db;
    return await db.update(
      'found_posts',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  // DELETE found post
  Future<int> deletePost(int id) async {
    final db = await _db;
    return await db.delete(
      'found_posts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

**Key Methods:**
- `getApprovedPosts()` - Only shows admin-approved posts
- `getPostById()` - Fetch single post (for LQITOU flow)
- `insertPost()` - Create new post (status='pending')
- `updatePost()` - Modify existing post
- `deletePost()` - Remove post (after contact unlock)

---

### 3.4 Model Classes (Data Transfer Objects)

**Purpose:** Type-safe representation of database rows

**Example: `FoundPost` model**
```dart
class FoundPost {
  final int? id;              // Nullable when creating (auto-generated)
  final String? photo;
  final String? description;
  final String status;        // 'pending', 'approved', 'rejected'
  final String? location;
  final String? category;
  final String? createdAt;
  final int? userId;

  FoundPost({...});

  // Convert database Map to FoundPost object
  factory FoundPost.fromMap(Map<String, dynamic> map) {
    return FoundPost(
      id: map['id'],
      photo: map['photo'],
      description: map['description'],
      status: map['status'],
      location: map['location'],
      category: map['category'],
      createdAt: map['created_at'],
      userId: map['user_id'],
    );
  }

  // Convert FoundPost object to database Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo': photo,
      'description': description,
      'status': status,
      'location': location,
      'category': category,
      'created_at': createdAt,
      'user_id': userId,
    };
  }
}
```

**Why `fromMap()` and `toMap()`?**
- SQLite returns data as `Map<String, dynamic>`
- We convert to type-safe objects for easier manipulation
- Convert back to Map when inserting/updating

---

## 4. CUBIT STATE MANAGEMENT

### 4.1 What is Cubit?

**Cubit** = Simplified version of BLoC pattern for state management

**Purpose:**
- Separates business logic from UI
- Reactive UI updates (UI rebuilds when state changes)
- Predictable state transitions
- Easy testing

---

### 4.2 Cubit Structure

```
lib/cubits/
├── auth/
│   ├── auth_cubit.dart       # Login, signup, logout logic
│   └── auth_state.dart       # Auth states (loading, authenticated, error)
├── found/
│   ├── found_cubit.dart      # Found posts logic
│   └── found_state.dart      # Found states
├── lost/
│   ├── lost_cubit.dart       # Lost posts logic
│   └── lost_state.dart       # Lost states
├── notification/
│   ├── notification_cubit.dart
│   └── notification_state.dart
└── user_profile/
    ├── user_profile_cubit.dart
    └── user_profile_state.dart
```

---

### 4.3 Example: `FoundCubit`

**States:**
```dart
// found_state.dart
abstract class FoundState {}

class FoundInitial extends FoundState {}

class FoundLoading extends FoundState {}

class FoundLoaded extends FoundState {
  final List<FoundPost> posts;
  FoundLoaded({required this.posts});
}

class FoundError extends FoundState {
  final String message;
  FoundError(this.message);
}
```

**Cubit:**
```dart
// found_cubit.dart
class FoundCubit extends Cubit<FoundState> {
  final FoundRepository _repository;
  List<FoundPost> _allPosts = [];

  FoundCubit(this._repository) : super(FoundInitial());

  // Load approved posts from database
  Future<void> loadApprovedPosts() async {
    emit(FoundLoading());  // Show loading spinner
    
    try {
      final posts = await _repository.getApprovedPosts();
      _allPosts = posts;  // Cache for search
      emit(FoundLoaded(posts: posts));  // Show posts
    } catch (e) {
      emit(FoundError('Failed to load posts'));  // Show error
    }
  }

  // Search posts (client-side filtering)
  void searchPosts(String query) {
    if (query.isEmpty) {
      emit(FoundLoaded(posts: _allPosts));
      return;
    }
    
    final filtered = _allPosts.where((post) {
      return post.description!.toLowerCase().contains(query.toLowerCase()) ||
             post.location!.toLowerCase().contains(query.toLowerCase()) ||
             post.category!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    
    emit(FoundLoaded(posts: filtered));
  }

  // Add new found post
  Future<void> addPost(FoundPost post) async {
    try {
      await _repository.insertPost(post);
      await loadApprovedPosts();  // Refresh list
    } catch (e) {
      emit(FoundError('Failed to add post'));
    }
  }

  // Refresh posts
  Future<void> refresh() async {
    await loadApprovedPosts();
  }
}
```

---

### 4.4 How UI Uses Cubit

```dart
// In FoundsPage
class FoundsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoundCubit, FoundState>(
      builder: (context, state) {
        if (state is FoundLoading) {
          return CircularProgressIndicator();  // Show loading
        }
        
        if (state is FoundError) {
          return Text(state.message);  // Show error
        }
        
        if (state is FoundLoaded) {
          return ListView.builder(  // Show posts
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return FoundItemCard(post: state.posts[index]);
            },
          );
        }
        
        return SizedBox.shrink();
      },
    );
  }
}
```

**Flow:**
1. User opens Founds page
2. `FoundCubit.loadApprovedPosts()` called
3. Emits `FoundLoading` → UI shows spinner
4. Repository fetches from database
5. Emits `FoundLoaded(posts)` → UI shows list
6. If error, emits `FoundError` → UI shows error message

---

## 5. AUTHENTICATION SYSTEM

### 5.1 Components

1. **`AuthCubit`** - Manages auth state (logged in/out)
2. **`AuthService`** - Session persistence (SharedPreferences)
3. **`UserRepository`** - Database operations

---

### 5.2 Login Flow

```dart
// AuthCubit
Future<void> login(String email, String password) async {
  emit(AuthLoading());
  
  try {
    // Validate credentials against database
    final userId = await _userRepository.validateCredentials(email, password);
    
    if (userId != null) {
      // Save session
      await _authService.saveSession(userId);
      emit(AuthAuthenticated(userId: userId));
    } else {
      emit(AuthError('Invalid credentials'));
    }
  } catch (e) {
    emit(AuthError('Login failed'));
  }
}
```

**UserRepository validation:**
```dart
Future<int?> validateCredentials(String email, String password) async {
  final db = await _db;
  final maps = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
    limit: 1,
  );
  
  if (maps.isEmpty) return null;
  return maps.first['id'] as int;
}
```

---

### 5.3 Session Persistence

**AuthService uses SharedPreferences:**
```dart
class AuthService {
  static const _userIdKey = 'user_id';
  
  // Save user ID to persistent storage
  Future<void> saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }
  
  // Load user ID on app startup
  Future<int?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }
  
  // Get current logged-in user
  int? get currentUserId {
    // Synchronous access to cached value
    return _cachedUserId;
  }
  
  // Logout
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}
```

**Why SharedPreferences?**
- Persists across app restarts
- Fast synchronous access
- Simple key-value storage

---

## 6. PAGE-BY-PAGE BREAKDOWN

### 6.1 Notifications Page

**File:** `lib/screens/notifications/notifications_page.dart`

**Purpose:** Display user-specific notifications

**Cubit:** `NotificationCubit`  
**Repository:** `NotificationRepository`

**Key Features:**
1. Load notifications for logged-in user
2. Mark notifications as read
3. Action buttons (Get Contact, Confirm Return)
4. Real-time refresh when tab becomes visible

**Implementation:**
```dart
class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationCubit _notificationCubit;
  late final int _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = AuthService().currentUserId ?? 1;
    _notificationCubit = getIt<NotificationCubit>();
    
    if (widget.isVisible) {
      _notificationCubit.loadAllNotifications(_currentUserId);
    }
  }

  @override
  void didUpdateWidget(NotificationsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reload when tab becomes visible
    if (!oldWidget.isVisible && widget.isVisible) {
      _notificationCubit.loadAllNotifications(_currentUserId);
    }
  }
}
```

**Database Query:**
```dart
// NotificationRepository
Future<List<NotificationModel>> getAllNotifications(int userId) async {
  final db = await _db;
  final maps = await db.query(
    'notifications',
    where: 'user_id = ?',
    whereArgs: [userId],
    orderBy: 'created_at DESC',
  );
  return maps.map((m) => NotificationModel.fromMap(m)).toList();
}
```

**Notification Types:**
- `'item_found'` - Someone clicked LQITOU on your lost post
- `'post_approved'` - Admin approved your post
- `'contact_unlocked'` - Someone unlocked your contact

---

### 6.2 Founds Page

**File:** `lib/screens/founds/founds_page.dart`

**Purpose:** Browse and report found items

**Cubit:** `FoundCubit`  
**Repository:** `FoundRepository`

**Key Features:**
1. Load approved found posts
2. Search/filter posts
3. Add new found item (via popup)
4. "LQitha" button to unlock contact

**Implementation:**
```dart
class _FoundsPageState extends State<FoundsPage> {
  late final FoundCubit _foundCubit;

  @override
  void initState() {
    super.initState();
    _foundCubit = getIt<FoundCubit>();
    _foundCubit.loadApprovedPosts();
  }

  void _onSearch(String query) {
    _foundCubit.searchPosts(query);
  }
}
```

**Database Query:**
```dart
// FoundRepository
Future<List<FoundPost>> getApprovedPosts() async {
  final db = await _db;
  final maps = await db.query(
    'found_posts',
    where: 'status = ?',
    whereArgs: ['approved'],
    orderBy: 'created_at DESC',
  );
  return maps.map((m) => FoundPost.fromMap(m)).toList();
}
```

**Admin Approval Workflow:**
1. User submits found item → `status = 'pending'`
2. Admin reviews in admin dashboard
3. Admin approves → `status = 'approved'`
4. Post appears in Founds page

---

### 6.3 Losts Page

**File:** `lib/screens/losts/losts_page.dart`

**Purpose:** Browse and report lost items

**Cubit:** `LostCubit`  
**Repository:** `LostRepository`

**Key Features:**
1. Load approved lost posts
2. Search/filter posts
3. Add new lost item (via popup)
4. **"LQITOU" button** - Complex multi-table operation

**LQITOU Flow (Most Important!):**
```dart
// In lost_item_card.dart
Future<void> _handleFoundItem(BuildContext context) async {
  final currentUserId = AuthService().currentUserId ?? 1;
  final lostRepository = getIt<LostRepository>();
  final foundRepository = getIt<FoundRepository>();
  final notificationRepository = getIt<NotificationRepository>();
  
  // 1. Get the lost post
  final lostPost = await lostRepository.getPostById(postId);
  if (lostPost == null) return;
  
  final postOwnerId = lostPost.userId!;
  final description = lostPost.description ?? 'your item';
  
  // 2. Create found post (same data, different user)
  final foundPost = FoundPost(
    photo: lostPost.photo,
    description: lostPost.description,
    status: 'approved',  // Auto-approve since it's a match
    location: lostPost.location,
    category: lostPost.category,
    createdAt: DateTime.now().toIso8601String(),
    userId: currentUserId,  // Person who found it
  );
  await foundRepository.insertPost(foundPost);
  
  // 3. Delete the lost post
  await lostRepository.deletePost(postId);
  
  // 4. Create notification for owner
  final notification = NotificationModel(
    title: 'Someone Found Your Item',
    message: 'Good news! Someone found your $description',
    relatedPostId: postId,
    type: 'item_found',
    isRead: false,
    createdAt: DateTime.now().toIso8601String(),
    userId: postOwnerId,  // Notification recipient
  );
  await notificationRepository.insertNotification(notification);
  
  // 5. Refresh UI
  context.read<LostCubit>().refresh();
  context.read<FoundCubit>().refresh();
}
```

**Why is LQITOU Complex?**
- Involves **4 tables**: lost_posts, found_posts, notifications, users
- **3 repositories**: LostRepository, FoundRepository, NotificationRepository
- **2 Cubits**: LostCubit, FoundCubit
- Must maintain data consistency

---

## 7. DATA FLOW EXAMPLES

### 7.1 Example: User Reports Found Item

```
1. User fills form in popup_found_item.dart
   ↓
2. FoundCubit.addPost(newPost) called
   ↓
3. FoundRepository.insertPost(newPost)
   ↓
4. SQLite INSERT INTO found_posts (status='pending', user_id=currentUserId)
   ↓
5. FoundCubit.loadApprovedPosts() (refresh)
   ↓
6. Post NOT visible yet (status='pending')
   ↓
7. Admin approves → UPDATE found_posts SET status='approved'
   ↓
8. Post now visible in Founds page
```

---

### 7.2 Example: User Unlocks Contact

```
1. User clicks "LQitha" on FoundItemCard
   ↓
2. PaymentPopup shown
   ↓
3. User clicks "Pay 200 DA"
   ↓
4. FoundRepository.deletePost(postId)
   ↓
5. SQLite DELETE FROM found_posts WHERE id=postId
   ↓
6. FoundCubit.refresh()
   ↓
7. Post removed from UI (item reunited!)
   ↓
8. ContactUnlockedPopup shown with contact info
```

---

### 7.3 Example: LQITOU Flow

```
1. User sees lost post in Losts page
   ↓
2. Clicks "LQITOU" button
   ↓
3. LostRepository.getPostById(postId)
   ↓
4. FoundRepository.insertPost(newFoundPost with currentUserId)
   ↓
5. LostRepository.deletePost(postId)
   ↓
6. NotificationRepository.insertNotification(for post owner)
   ↓
7. LostCubit.refresh() + FoundCubit.refresh()
   ↓
8. Lost post disappears, found post appears, owner gets notification
```

---

## 8. EXPECTED QUESTIONS & ANSWERS

### Q1: "Explain your database schema"

**A:** "We have 4 tables: users, found_posts, lost_posts, and notifications. The users table is the parent with foreign key relationships to the other three. Each post table has a user_id foreign key with ON DELETE CASCADE, meaning if a user is deleted, all their posts and notifications are automatically deleted. The status field in posts enables admin approval workflow - posts start as 'pending' and must be approved before appearing in the feed."

---

### Q2: "How does the database seeder work?"

**A:** "The seeder runs on app startup in main.dart. It first checks if the database has any users by running SELECT COUNT(*) FROM users. If the count is greater than 0, it skips seeding to preserve existing data. If the database is empty, it seeds 5 test users, 4 found posts, 4 lost posts, and 4 notifications using a transaction to ensure atomicity. This means user-created accounts and posts persist across app restarts."

---

### Q3: "What is the repository pattern and why use it?"

**A:** "The repository pattern abstracts database operations into dedicated classes - one per table. For example, FoundRepository handles all queries for the found_posts table. This separates data access from business logic, making the code more maintainable and testable. Repositories also handle type-safe conversions between database Maps and model objects using fromMap() and toMap() methods."

---

### Q4: "Explain the BLoC/Cubit pattern"

**A:** "Cubit is a simplified version of BLoC for state management. Each Cubit manages state for a specific feature - for example, FoundCubit manages found posts. It has methods like loadApprovedPosts() that emit different states: FoundLoading, FoundLoaded, or FoundError. The UI listens to these state changes using BlocBuilder and rebuilds automatically. This separates business logic from UI and makes state changes predictable and testable."

---

### Q5: "How does authentication work?"

**A:** "Authentication uses three components: AuthCubit for state management, UserRepository for database validation, and AuthService for session persistence. When a user logs in, AuthCubit calls UserRepository.validateCredentials() which queries the users table with email and password. If valid, AuthService saves the userId to SharedPreferences for persistence. On app startup, AuthService loads the saved userId to auto-login the user."

---

### Q6: "Explain the LQITOU flow"

**A:** "LQITOU is the most complex feature. When someone clicks LQITOU on a lost post, it:
1. Fetches the lost post from database
2. Creates a found post with the same data but attributed to the finder
3. Deletes the original lost post
4. Creates a notification for the post owner
5. Refreshes both Losts and Founds pages

This involves 4 tables and 3 repositories, demonstrating complex multi-table operations while maintaining data consistency."

---

### Q7: "How do you handle admin approval?"

**A:** "All posts have a status field that defaults to 'pending'. When users submit posts, they're inserted with status='pending'. The repository methods like getApprovedPosts() only query posts WHERE status='approved'. Admins can update the status to 'approved' or 'rejected' through an admin dashboard. This prevents spam and ensures quality control."

---

### Q8: "Why use foreign keys with CASCADE?"

**A:** "Foreign keys enforce referential integrity - you can't create a post with a user_id that doesn't exist. ON DELETE CASCADE means if a user is deleted, all their related data (posts, notifications) is automatically deleted too. This prevents orphaned records and maintains database consistency without manual cleanup."

---

### Q9: "How does the notification system work?"

**A:** "Notifications are triggered by events like LQITOU clicks. When the event occurs, we insert a record into the notifications table with the recipient's user_id and a type like 'item_found'. The NotificationCubit queries notifications WHERE user_id = currentUserId to show only relevant notifications. The is_read field tracks read status, and related_post_id links notifications to the relevant post."

---

### Q10: "Show me the data flow for adding a found item"

**A:** "User fills the form → FoundCubit.addPost() called → FoundRepository.insertPost() executes SQLite INSERT with status='pending' → FoundCubit.loadApprovedPosts() refreshes → Post NOT visible yet because status is pending → Admin approves → UPDATE status='approved' → Post now appears in feed. This demonstrates the full stack: UI → Cubit → Repository → Database → back to UI."

---

## QUICK REFERENCE CHEAT SHEET

### Database Tables
- `users` - User accounts (email UNIQUE, role, points)
- `found_posts` - Items people found (status, user_id FK)
- `lost_posts` - Items people lost (status, user_id FK)
- `notifications` - User alerts (type, is_read, user_id FK)

### Repositories
- `UserRepository` - User CRUD, validateCredentials()
- `FoundRepository` - getApprovedPosts(), insertPost(), deletePost()
- `LostRepository` - getApprovedPosts(), insertPost(), deletePost()
- `NotificationRepository` - getAllNotifications(), markAsRead()

### Cubits
- `AuthCubit` - login(), signup(), logout()
- `FoundCubit` - loadApprovedPosts(), searchPosts(), addPost()
- `LostCubit` - loadApprovedPosts(), searchPosts(), addPost()
- `NotificationCubit` - loadAllNotifications(), markAsRead()

### Key Flows
- **Login:** AuthCubit → UserRepository → SQLite → AuthService
- **Browse:** FoundCubit → FoundRepository → SQLite → UI
- **LQITOU:** LostRepo + FoundRepo + NotifRepo → 3 tables → 2 Cubits

---

**YOU'RE READY! 🚀**
