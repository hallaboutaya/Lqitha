# Lqitha Flask API Contract

## Overview
This document defines the REST API endpoints that the Flask backend must implement to support the Lqitha Flutter mobile app. The API will connect to Supabase PostgreSQL database and replace direct SQLite access.

## Base URL
```
http://localhost:5000  # Development
https://your-api.com   # Production
```

## Authentication
All endpoints (except `/auth/login` and `/auth/register`) require authentication.

**Authentication Method**: Bearer Token or Session-based (your choice)

**Headers**:
```
Authorization: Bearer {token}
Content-Type: application/json
```

## Database Schema

### PostgreSQL Tables (migrated from SQLite)

#### `users` table
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,  -- Store hashed passwords
    phone_number TEXT,
    photo TEXT,
    role TEXT DEFAULT 'user',  -- 'user' or 'admin'
    points INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### `found_posts` table
```sql
CREATE TABLE found_posts (
    id SERIAL PRIMARY KEY,
    photo TEXT,
    description TEXT,
    status TEXT DEFAULT 'pending',  -- 'pending', 'approved', 'rejected'
    location TEXT,
    category TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER REFERENCES users(id)
);
```

#### `lost_posts` table
```sql
CREATE TABLE lost_posts (
    id SERIAL PRIMARY KEY,
    photo TEXT,
    description TEXT,
    status TEXT DEFAULT 'pending',  -- 'pending', 'approved', 'rejected'
    location TEXT,
    category TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER REFERENCES users(id)
);
```

#### `notifications` table
```sql
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    related_post_id INTEGER,
    type TEXT,  -- 'found_match', 'post_approved', 'post_rejected', 'claim_request'
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER REFERENCES users(id)
);
```

## API Endpoints

### 🔐 Authentication

#### POST `/auth/login`
Login with email and password.

**Request**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "user": {
    "id": 1,
    "username": "John Doe",
    "email": "user@example.com",
    "phone_number": "+1234567890",
    "photo": null,
    "role": "user",
    "points": 150,
    "created_at": "2025-01-15T10:30:00Z",
    "updated_at": "2025-01-20T14:20:00Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response** (401 Unauthorized):
```json
{
  "success": false,
  "error": "Invalid email or password"
}
```

---

#### POST `/auth/register`
Create a new user account.

**Request**:
```json
{
  "username": "John Doe",
  "email": "user@example.com",
  "password": "password123",
  "phone_number": "+1234567890"
}
```

**Response** (201 Created):
```json
{
  "success": true,
  "user": {
    "id": 5,
    "username": "John Doe",
    "email": "user@example.com",
    "phone_number": "+1234567890",
    "photo": null,
    "role": "user",
    "points": 0,
    "created_at": "2025-01-27T21:15:00Z",
    "updated_at": "2025-01-27T21:15:00Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response** (400 Bad Request):
```json
{
  "success": false,
  "error": "Email already exists"
}
```

---

#### GET `/auth/check-email?email={email}`
Check if an email is already registered.

**Response** (200 OK):
```json
{
  "exists": true
}
```

---

### 📦 Found Posts

#### GET `/found-posts`
Get all approved found posts (for main feed).

**Query Parameters**:
- `search` (optional): Search query for description/location/category
- `user_id` (optional): Filter by user ID
- `status` (optional): Filter by status ('pending', 'approved', 'rejected')

**Response** (200 OK):
```json
{
  "success": true,
  "posts": [
    {
      "id": 1,
      "photo": "https://storage.url/photo1.jpg",
      "description": "Found a black wallet near the library",
      "status": "approved",
      "location": "Main Library",
      "category": "Wallet",
      "created_at": "2025-01-25T10:30:00Z",
      "user_id": 2
    },
    {
      "id": 3,
      "photo": null,
      "description": "Found keys with a blue keychain",
      "status": "approved",
      "location": "Parking Lot B",
      "category": "Keys",
      "created_at": "2025-01-26T14:20:00Z",
      "user_id": 4
    }
  ]
}
```

---

#### GET `/found-posts/all`
Get ALL found posts regardless of status (admin only).

**Response**: Same format as `/found-posts` but includes pending/rejected posts.

---

#### GET `/found-posts/{id}`
Get a specific found post by ID.

**Response** (200 OK):
```json
{
  "success": true,
  "post": {
    "id": 1,
    "photo": "https://storage.url/photo1.jpg",
    "description": "Found a black wallet near the library",
    "status": "approved",
    "location": "Main Library",
    "category": "Wallet",
    "created_at": "2025-01-25T10:30:00Z",
    "user_id": 2
  }
}
```

**Response** (404 Not Found):
```json
{
  "success": false,
  "error": "Post not found"
}
```

---

#### POST `/found-posts`
Create a new found post.

**Request**:
```json
{
  "photo": "https://storage.url/photo.jpg",  // Optional
  "description": "Found a black wallet near the library",
  "location": "Main Library",
  "category": "Wallet",
  "user_id": 2
}
```

**Response** (201 Created):
```json
{
  "success": true,
  "post": {
    "id": 10,
    "photo": "https://storage.url/photo.jpg",
    "description": "Found a black wallet near the library",
    "status": "pending",  // Always starts as pending
    "location": "Main Library",
    "category": "Wallet",
    "created_at": "2025-01-27T21:20:00Z",
    "user_id": 2
  }
}
```

---

#### PUT `/found-posts/{id}`
Update an existing found post (user can edit their own posts).

**Request**:
```json
{
  "photo": "https://storage.url/updated-photo.jpg",
  "description": "Updated description",
  "location": "Updated location",
  "category": "Updated category"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "post": {
    "id": 10,
    "photo": "https://storage.url/updated-photo.jpg",
    "description": "Updated description",
    "status": "pending",
    "location": "Updated location",
    "category": "Updated category",
    "created_at": "2025-01-27T21:20:00Z",
    "user_id": 2
  }
}
```

---

#### PUT `/found-posts/{id}/status`
Update post status (admin only).

**Request**:
```json
{
  "status": "approved"  // or "rejected"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Post status updated successfully"
}
```

---

#### DELETE `/found-posts/{id}`
Delete a found post (admin or post owner).

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Post deleted successfully"
}
```

---

### 🔍 Lost Posts

All lost post endpoints mirror the found post endpoints with `/lost-posts` prefix:

- `GET /lost-posts` - Get approved lost posts
- `GET /lost-posts/all` - Get all lost posts (admin)
- `GET /lost-posts/{id}` - Get specific lost post
- `POST /lost-posts` - Create new lost post
- `PUT /lost-posts/{id}` - Update lost post
- `PUT /lost-posts/{id}/status` - Update status (admin)
- `DELETE /lost-posts/{id}` - Delete lost post

Request/response formats are identical to found posts.

---

### 🎯 LQITOU Flow (Claim Post)

#### POST `/posts/{id}/claim`
User claims they found/lost an item (LQITOU flow).

**Request**:
```json
{
  "post_type": "found",  // or "lost"
  "claimer_user_id": 3,
  "message": "This is my wallet! I can prove it."
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Claim request sent successfully",
  "notification": {
    "id": 15,
    "title": "Someone claimed your found item!",
    "message": "A user claims they own the wallet you found.",
    "related_post_id": 1,
    "type": "claim_request",
    "is_read": false,
    "created_at": "2025-01-27T21:25:00Z",
    "user_id": 2  // Post owner
  }
}
```

**Backend Logic**:
1. Create a notification for the post owner
2. Optionally update post status or create a "claim" record
3. Return success response

---

### 🔔 Notifications

#### GET `/notifications?user_id={user_id}`
Get all notifications for a user.

**Query Parameters**:
- `user_id` (required): User ID
- `unread` (optional): If `true`, return only unread notifications
- `type` (optional): Filter by notification type

**Response** (200 OK):
```json
{
  "success": true,
  "notifications": [
    {
      "id": 1,
      "title": "Post Approved!",
      "message": "Your found post has been approved by admin.",
      "related_post_id": 5,
      "type": "post_approved",
      "is_read": false,
      "created_at": "2025-01-27T10:00:00Z",
      "user_id": 2
    },
    {
      "id": 2,
      "title": "Someone claimed your item!",
      "message": "A user claims they own the wallet you found.",
      "related_post_id": 1,
      "type": "claim_request",
      "is_read": true,
      "created_at": "2025-01-26T15:30:00Z",
      "user_id": 2
    }
  ]
}
```

---

#### GET `/notifications/unread-count?user_id={user_id}`
Get count of unread notifications.

**Response** (200 OK):
```json
{
  "success": true,
  "count": 3
}
```

---

#### PUT `/notifications/{id}/read`
Mark a notification as read.

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Notification marked as read"
}
```

---

#### PUT `/notifications/mark-all-read?user_id={user_id}`
Mark all notifications as read for a user.

**Response** (200 OK):
```json
{
  "success": true,
  "message": "All notifications marked as read"
}
```

---

#### POST `/notifications`
Create a new notification (typically called by backend, not Flutter app).

**Request**:
```json
{
  "title": "Post Approved!",
  "message": "Your found post has been approved.",
  "related_post_id": 5,
  "type": "post_approved",
  "user_id": 2
}
```

**Response** (201 Created):
```json
{
  "success": true,
  "notification": {
    "id": 20,
    "title": "Post Approved!",
    "message": "Your found post has been approved.",
    "related_post_id": 5,
    "type": "post_approved",
    "is_read": false,
    "created_at": "2025-01-27T21:30:00Z",
    "user_id": 2
  }
}
```

---

### 👤 Users

#### GET `/users/{id}`
Get user profile by ID.

**Response** (200 OK):
```json
{
  "success": true,
  "user": {
    "id": 1,
    "username": "John Doe",
    "email": "user@example.com",
    "phone_number": "+1234567890",
    "photo": "https://storage.url/profile.jpg",
    "role": "user",
    "points": 150,
    "created_at": "2025-01-15T10:30:00Z",
    "updated_at": "2025-01-20T14:20:00Z"
  }
}
```

---

#### GET `/users/{id}/username`
Get just the username (lightweight query).

**Response** (200 OK):
```json
{
  "success": true,
  "username": "John Doe"
}
```

---

#### GET `/users/by-email?email={email}`
Get user by email address.

**Response**: Same as `/users/{id}`

---

#### PUT `/users/{id}`
Update user profile.

**Request**:
```json
{
  "username": "John Updated",
  "email": "newemail@example.com",
  "phone_number": "+9876543210",
  "photo": "https://storage.url/new-profile.jpg"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "user": {
    "id": 1,
    "username": "John Updated",
    "email": "newemail@example.com",
    "phone_number": "+9876543210",
    "photo": "https://storage.url/new-profile.jpg",
    "role": "user",
    "points": 150,
    "created_at": "2025-01-15T10:30:00Z",
    "updated_at": "2025-01-27T21:35:00Z"
  }
}
```

---

#### PUT `/users/{id}/photo`
Update user profile photo.

**Request**:
```json
{
  "photo": "https://storage.url/new-photo.jpg"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Photo updated successfully"
}
```

---

## Error Responses

All error responses follow this format:

```json
{
  "success": false,
  "error": "Error message description"
}
```

**Common HTTP Status Codes**:
- `200 OK` - Request successful
- `201 Created` - Resource created successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required or failed
- `403 Forbidden` - User doesn't have permission
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server error

---

## Date/Time Format

All timestamps should be in **ISO 8601 format**:
```
2025-01-27T21:30:00Z
```

Flutter will parse these using `DateTime.parse()`.

---

## Image Handling

**Options**:
1. **Base64 encoding**: Flutter sends base64-encoded images in JSON
2. **File upload**: Use multipart/form-data for image uploads
3. **Cloud storage**: Flutter uploads to cloud storage (e.g., Supabase Storage), sends URL to API

**Recommendation**: Use Supabase Storage for images, send URLs in API requests.

---

## Testing the API

### Example cURL Commands

**Login**:
```bash
curl -X POST http://localhost:5000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

**Get Found Posts**:
```bash
curl -X GET http://localhost:5000/found-posts \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Create Found Post**:
```bash
curl -X POST http://localhost:5000/found-posts \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "description":"Found a black wallet",
    "location":"Library",
    "category":"Wallet",
    "user_id":1
  }'
```

---

## Implementation Notes

### Admin Approval Workflow
1. User creates post → status = `'pending'`
2. Admin reviews post → updates status to `'approved'` or `'rejected'`
3. Only `'approved'` posts appear in main feeds
4. Create notification when post is approved/rejected

### LQITOU Flow Explanation
**LQITOU** = "I found it" in Arabic

**Scenario**: User A posts a found item. User B lost that item and wants to claim it.

1. User B clicks "LQITOU" button on User A's found post
2. Flutter app calls `POST /posts/{id}/claim`
3. Backend creates notification for User A
4. User A receives notification and can contact User B
5. They arrange to return the item

### Security Considerations
- Hash passwords using bcrypt or similar
- Validate user owns a post before allowing updates/deletes
- Implement rate limiting to prevent spam
- Sanitize user inputs to prevent SQL injection
- Use HTTPS in production

---

## Questions?
Contact Flutter developer (you) for clarification on any endpoints or data formats.
