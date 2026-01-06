# 🎮 Rewards System Documentation

## Overview
The Lqitha app includes a comprehensive gamification system that rewards users for positive actions and tracks all point transactions.

---

## Point Rules

| Action | Points | When Triggered |
|--------|--------|----------------|
| **Create Post** | +5 | User submits a found/lost item |
| **Post Approved** | +10 | Admin approves the post |
| **Post Rejected** | -5 | Admin rejects spam/invalid post |
| **Contact Unlocked** | -20 | User pays to view contact info |
| **Item Returned** | +50 | LQITOU flow completed (future) |

---

## Database Schema

### `trust_point_transactions`
Tracks every point change with full audit trail.

```sql
CREATE TABLE trust_point_transactions (
    id uuid PRIMARY KEY,
    user_id uuid REFERENCES users(id),
    points integer NOT NULL,
    transaction_type text NOT NULL,
    description text NOT NULL,
    related_post_id uuid,
    related_post_type text,  -- 'found' or 'lost'
    created_at timestamptz DEFAULT NOW()
);
```

---

## Backend API

### Endpoints

#### `GET /rewards/transactions?user_id={id}&limit={n}`
Fetch transaction history for a user.

**Response:**
```json
{
  "success": true,
  "transactions": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "points": 10,
      "transaction_type": "post_approved",
      "description": "Your found post was approved",
      "related_post_id": "uuid",
      "related_post_type": "found",
      "created_at": "2026-01-01T12:00:00Z"
    }
  ]
}
```

#### `GET /rewards/leaderboard?limit={n}`
Get top users by points.

**Response:**
```json
{
  "success": true,
  "leaderboard": [
    {
      "id": "uuid",
      "username": "John Doe",
      "photo": "url",
      "points": 350
    }
  ]
}
```

### Auto-Award Logic

Points are automatically awarded/deducted in:
- **`app/routes/posts.py`**: Awards +5 when post is created
- **`app/routes/admin.py`**: Awards +10 on approval, -5 on rejection

---

## Flutter Implementation

### Models
- **`PointTransaction`** (`lib/data/models/point_transaction.dart`)

### Repositories
- **`RewardsRepository`** (`lib/data/repositories/rewards_repository.dart`)
  - `getTransactions(userId, limit)`
  - `getLeaderboard(limit)`

### UI Components
- **`RecentActivity`** (`lib/widgets/profile/recent_activity.dart`)
  - Displays last 5 transactions
  - Uses `timeago` package for relative timestamps
  - Auto-refreshes on profile load

---

## Usage Example

### Backend (Python)
```python
from app.routes.rewards import award_points

# Award points manually
award_points(
    user_id='uuid',
    points=50,
    transaction_type='item_returned',
    description='Successfully returned lost wallet',
    related_post_id='post-uuid',
    related_post_type='found'
)
```

### Frontend (Flutter)
```dart
final repo = RewardsRepository();
final transactions = await repo.getTransactions(userId, limit: 10);
```

---

## Future Enhancements
- [ ] Badges/Achievements (Bronze, Silver, Gold tiers)
- [ ] Weekly leaderboard reset
- [ ] Point redemption system (exchange points for premium features)
- [ ] Push notifications on point changes
