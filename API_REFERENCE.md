# 📡 API Reference & Database Schema

**Base URL**: `http://localhost:5000` (Dev) / `https://production-url.com` (Prod)

## 🗄️ Database Schema (PostgreSQL)

### `users`
| Column | Type | Notes |
|--------|------|-------|
| `id` | SERIAL (PK) | Unique ID |
| `username` | TEXT | Display Name |
| `email` | TEXT | Unique Email |
| `password` | TEXT | **Bcrypt Hash** |
| `role` | TEXT | `user` or `admin` |
| `points` | INTEGER | Gamification score |

### `found_posts` / `lost_posts`
| Column | Type | Notes |
|--------|------|-------|
| `id` | SERIAL (PK) | Unique ID |
| `user_id` | INTEGER (FK) | Owner |
| `description` | TEXT | Details |
| `status` | TEXT | `pending`, `approved`, `rejected` |
| `location` | TEXT | Where it was found/lost |
| `created_at` | TIMESTAMPTZ | ISO 8601 |

---

## 🔐 Authentication

**Headers Required**: `Authorization: Bearer <token>` (for all non-auth routes)

### `POST /auth/register`
Create a new account.
```json
// Request
{
  "email": "user@example.com",
  "password": "securePassword123", /* Min 8 chars */
  "username": "John Doe",
  "phone_number": "+1234567890"
}
```

### `POST /auth/login`
Get access token.
```json
// Response
{
  "success": true,
  "token": "eyJh... (JWT)",
  "user": { ... }
}
```

---

## 📦 Posts

### `GET /found-posts`
Fetch *approved* found items.
*   **Query Params**:
    *   `search`: Keyword search (loc, desc, cat)
    *   `limit`: (Optional) Pagination limit

### `POST /found-posts`
Submit a new item (Starts as `pending`).
```json
{
  "description": "Red backpack",
  "location": "Library",
  "category": "Bags"
}
```

*(Same endpoints apply for `/lost-posts`)*

---

## 🔔 Notifications

### `GET /notifications`
Fetch user alerts.

### `PUT /notifications/<id>/read`
Mark specific alert as read.

---

## 🛡️ Admin

**Requires**: `role: 'admin'` in JWT.

### `GET /admin/statistics`
Returns platform stats (Total posts, Pending count, Active users).

### `PUT /admin/status/found/<id>`
Approve or Reject a post.
```json
{ "status": "approved" }
```
