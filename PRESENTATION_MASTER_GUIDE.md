# 🎓 Lqitha Presentation Master Guide

This "cheat sheet" is designed to help you navigate the code during your presentation. It covers the most important functions, where to find them, and how to explain or modify them on the fly.

---

## 1. Authentication (Login & Signup)

### **Where is the logic?**
- **Frontend**: [`lib/cubits/auth/auth_cubit.dart`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/lib/cubits/auth/auth_cubit.dart)
- **Functions**: `login(email, password)` and `signUp(username, email, password, phone)`
- **Backend**: [`flask_backend/app/routes/auth.py`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/flask_backend/app/routes/auth.py)

### **What does it do?**
1. Sends credentials to the Flask API.
2. The Backend verifies the email/password using `bcrypt` (hashing).
3. If valid, the backend returns a **JWT Token**.
4. The Cubit saves the token and updates the UI to `AuthAuthenticated`.

### **"Change it for me"** (Example):
> *Professor: "Change the login to allow any password for testing."*
> - Go to `auth.py` in the backend.
> - Find the line: `if user and check_password_hash(user.password, password):`
> - Change it to: `if user:  # skip password check`

---

## 2. Post Management & Admin Approval

### **Where is the logic?**
- **Admin Actions**: [`lib/cubits/admin/admin_cubit.dart`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/lib/cubits/admin/admin_cubit.dart)
- **Functions**: `approvePost(id, type)` and `rejectPost(id, type)`
- **Backend Logic**: [`flask_backend/app/routes/admin.py`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/flask_backend/app/routes/admin.py)

### **What does it do?**
- `approvePost`: Updates the post status to `'approved'` in the database. This makes it visible to all users.
- **Bonus**: It also automatically creates a **Notification** for the user who posted it ([AdminCubit:L92-L114](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/lib/cubits/admin/admin_cubit.dart#L92-L114)).

### **"Change it for me"** (Example):
> *Professor: "Make posts approved by default without admin review."*
> - Go to [`lib/cubits/found/found_cubit.dart`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/lib/cubits/found/found_cubit.dart).
> - In `addPost`, look for the `status: 'pending'` model property.
> - Change it to: `status: 'approved'`.

---

## 3. The Rewards & Points System

### **Where is the logic?**
- **Backend Route**: [`flask_backend/app/routes/rewards.py`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/flask_backend/app/routes/rewards.py)
- **Trigger Points**: Look for `award_points()` calls in `admin.py` and `posts.py`.

### **Point Values**:
| Action | File | Search For | Default |
|---|---|---|---|
| **Approve Post** | `admin.py` | `award_points` | +10 |
| **Create Post** | `posts.py` | `award_points` | +5 |
| **Unlock Contact** | `unlocks.py` | `deduct_points` | -20 |

### **"Change it for me"** (Example):
> *Professor: "Double the reward for finding an item."*
> - Go to `flask_backend/app/routes/admin.py`.
> - Find the `approve_post` route.
> - Change the `points=10` argument to `points=20`.

---

## 4. Multi-Language (Internationalization)

### **Where is the logic?**
- **Cubit**: [`lib/cubits/locale/locale_cubit.dart`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/lib/cubits/locale/locale_cubit.dart)
- **Translation Files**: [`lib/l10n/app_en.arb`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/lib/l10n/app_en.arb) and `app_ar.arb`.

### **What does it do?**
- The `LocaleCubit` changes the `Locale` object in the `MaterialApp`.
- Flutter automatically looks up the ARB files to replace keys (like `@login_title`) with the translated text.

---

## 5. LQITOU (The Claim Flow)

### **Where is the logic?**
- **Trigger**: `FoundsPage` or `LostsPage` "Claim" button.
- **Repository**: [`lib/data/repositories/notification_repository.dart`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/lib/data/repositories/notification_repository.dart)
- **Backend**: [`flask_backend/app/routes/notifications.py`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/flask_backend/app/routes/notifications.py)

### **The Logic Sequence**:
1. User clicks "Claim".
2. App sends a request to the backend.
3. Backend creates a new row in the `notifications` table for the *original poster*.
4. The poster sees the notification and chooses whether to share contact info.

---

## 🎯 Pro Presentation Tips:
- **Navigation**: If he asks where the pages are linked, go to `lib/main.dart` or your `CustomBottomNavigationBar`.
- **Database**: If he asks about the DB schema, show him [`flask_backend/schema.sql`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/flask_backend/schema.sql) or the **Supabase Dashboard**.
- **Clean Code**: Mention that we use **GetIt** for "Dependency Injection" so we can swap SQLite/API easily ([`lib/services/service_locator.dart`](file:///c:/3rd%20Year/Mobilelabs/Lqitha-halaaaaa/lib/services/service_locator.dart)).
