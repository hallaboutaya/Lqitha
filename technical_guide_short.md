# Lqitha - Technical Guide (Condensed)

## 1. DATABASE SCHEMA (4 Tables)

### users
```sql
id, username, email (UNIQUE), password, phone_number, photo, 
role ('user'/'admin'), points, created_at, updated_at
```

### found_posts & lost_posts
```sql
id, photo, description, status ('pending'/'approved'/'rejected'),
location, category, created_at, user_id (FK → users.id)
```

### notifications
```sql
id, title, message, related_post_id, type ('item_found'/'post_approved'),
is_read (0/1), created_at, user_id (FK → users.id)
```

**Foreign Keys:** All with `ON DELETE CASCADE` (delete user → delete their posts/notifications)

---

## 2. DATABASE SEEDER

**Location:** `lib/services/database_seeder.dart`

**Logic:**
```dart
1. Check: SELECT COUNT(*) FROM users
2. If count > 0 → SKIP seeding (preserve data)
3. If count = 0 → Seed test data
```

**Seeds:**
- 5 users (Sarah, Ahmed, Karim, Amina, Admin)
- 4 found posts (all approved)
- 4 lost posts (all approved)
- 4 notifications

**When it seeds:**
- ✅ First app launch
- ❌ Hot reload/restart
- ❌ Stop & flutter run
- ✅ Uninstall & reinstall

**Key:** User-created data PERSISTS across app restarts!

---

## 3. REPOSITORY PATTERN

**Purpose:** Abstracts database operations, one class per table

**Example: FoundRepository**
```dart
- getApprovedPosts() → WHERE status='approved'
- getPostById(id) → Single post
- insertPost(post) → INSERT with status='pending'
- updatePost(post) → UPDATE
- deletePost(id) → DELETE
```

**Model Classes:** Type-safe objects with `fromMap()` and `toMap()`

---

## 4. CUBIT STATE MANAGEMENT

**Pattern:** UI ← State ← Cubit ← Repository ← Database

**States:**
- `FoundLoading` → Show spinner
- `FoundLoaded(posts)` → Show list
- `FoundError(message)` → Show error

**Example Flow:**
```dart
FoundCubit.loadApprovedPosts()
  → emit(FoundLoading)
  → Repository.getApprovedPosts()
  → emit(FoundLoaded(posts))
  → UI rebuilds with BlocBuilder
```

---

## 5. AUTHENTICATION

**Components:**
- `AuthCubit` - State management
- `AuthService` - Session (SharedPreferences)
- `UserRepository` - Database validation

**Login Flow:**
```
1. User enters email/password
2. AuthCubit.login() → UserRepository.validateCredentials()
3. Query: SELECT id FROM users WHERE email=? AND password=?
4. If valid → AuthService.saveSession(userId)
5. Emit AuthAuthenticated(userId)
```

---

## 6. KEY FEATURES

### Notifications Page
- Load user-specific notifications: `WHERE user_id = currentUserId`
- Mark as read, action buttons
- Reloads when tab becomes visible

### Founds Page
- Load approved posts: `WHERE status = 'approved'`
- Client-side search (description, location, category)
- Add new post → status='pending' → admin approval

### Losts Page
- Load approved posts
- **LQITOU Flow** (most complex):
  1. Get lost post
  2. Create found post (same data, different user)
  3. Delete lost post
  4. Create notification for owner
  5. Refresh both pages

---

## 7. LQITOU FLOW (DETAILED)

```dart
// 4 tables involved: lost_posts, found_posts, notifications, users
// 3 repositories: LostRepository, FoundRepository, NotificationRepository

1. LostRepository.getPostById(postId)
2. FoundRepository.insertPost(new FoundPost with currentUserId)
3. LostRepository.deletePost(postId)
4. NotificationRepository.insertNotification(for post owner)
5. LostCubit.refresh() + FoundCubit.refresh()
```

**Why complex?** Multi-table transaction ensuring data consistency

---

## 8. ADMIN APPROVAL WORKFLOW

```
User submits post → status='pending'
Admin reviews → UPDATE status='approved'
Post appears in feed (getApprovedPosts only shows approved)
```

---

## 9. ESSENTIAL Q&A

**Q: Explain database schema**  
A: 4 tables with foreign keys. Users is parent, posts/notifications are children with ON DELETE CASCADE. Status field enables admin approval workflow.

**Q: How does seeder work?**  
A: Checks user count. If >0, skips to preserve data. If 0, seeds test data in transaction. User data persists across restarts.

**Q: What is repository pattern?**  
A: Abstracts database ops into classes. FoundRepository handles found_posts queries. Separates data access from business logic, enables testing.

**Q: Explain BLoC/Cubit**  
A: State management. Cubit emits states (Loading/Loaded/Error), UI rebuilds with BlocBuilder. Separates business logic from UI.

**Q: How does auth work?**  
A: AuthCubit validates credentials via UserRepository query. On success, AuthService saves userId to SharedPreferences for persistence.

**Q: Explain LQITOU flow**  
A: Multi-table operation: fetch lost post → create found post → delete lost post → notify owner → refresh UI. Uses 3 repositories, maintains consistency.

**Q: Why foreign keys with CASCADE?**  
A: Enforces referential integrity. Prevents orphaned records. If user deleted, all their data auto-deleted.

**Q: How do notifications work?**  
A: Events trigger insertNotification(). NotificationCubit queries WHERE user_id=currentUserId. Shows only relevant notifications.

---

## 10. QUICK REFERENCE

**Test Accounts:**
- User: `sarah@example.com` / `password123`
- Admin: `admin@lqitha.com` / `admin123`

**Key Files:**
- Database: `lib/data/databases/db_helper.dart`
- Seeder: `lib/services/database_seeder.dart`
- Repos: `lib/data/repositories/`
- Cubits: `lib/cubits/`
- Pages: `lib/screens/`

**Architecture:**
```
UI → Cubit → Repository → SQLite
     ↓
   State → BlocBuilder → UI rebuild
```

---


