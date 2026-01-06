# Testing Guide

## Test Structure

The test suite is organized into:

### Unit Tests (`test_unit.py`)
Tests individual functions in isolation:
- Password hashing/verification
- Email validation
- Password strength validation

### Integration Tests (`test_integration.py`)
Tests complete API workflows:
- **Authentication**: Register, login, duplicate email handling
- **Posts**: Create found/lost posts, verify point awards
- **Admin**: Approve/reject posts, verify point changes
- **Rewards**: Transaction history, leaderboard
- **Complete Flow**: End-to-end post creation → approval → point tracking

---

## Running Tests

### Run All Tests
```bash
cd flask_backend
pytest
```

### Run Specific Test File
```bash
pytest tests/test_unit.py
pytest tests/test_integration.py
```

### Run Specific Test
```bash
pytest tests/test_integration.py::test_create_found_post
```

### Run with Verbose Output
```bash
pytest -v
```

### Run with Coverage Report
```bash
pytest --cov=app --cov-report=html
```

---

## Test Coverage

### Current Coverage

**Unit Tests:**
- ✅ Password hashing (bcrypt)
- ✅ Email validation
- ✅ Password strength validation

**Integration Tests:**
- ✅ User registration
- ✅ User login (valid/invalid)
- ✅ Create found/lost posts
- ✅ Auto-award +5 points on post creation
- ✅ Admin approve post (+10 points)
- ✅ Admin reject post (-5 points)
- ✅ Fetch transaction history
- ✅ Fetch leaderboard
- ✅ Fetch notifications
- ✅ Complete post approval flow
- ✅ Unauthorized access handling

---

## Prerequisites

### 1. Supabase Database
Tests require a live Supabase connection. Make sure:
- `.env` file is configured with valid credentials
- Database tables exist (run `schema.sql`)

### 2. Admin User
Some tests require an admin user. Create one:
```python
# In Supabase SQL Editor or via /auth/register then manually update role
UPDATE users SET role = 'admin' WHERE email = 'admin@lqitha.com';
```

---

## Test Fixtures

### `app`
Creates a Flask test app instance.

### `client`
HTTP client for making API requests.

### `auth_headers`
Registers a test user and returns auth headers + user_id.

### `admin_headers`
Logs in as admin and returns auth headers.

---

## Important Notes

### Test Isolation
- Each test run uses unique email addresses (timestamped)
- Tests create real data in Supabase
- Consider using a separate test database

### Cleanup
Tests do NOT automatically clean up created data. To reset:
```sql
-- Clear test data (CAUTION: This deletes everything!)
TRUNCATE users, found_posts, lost_posts, notifications, trust_point_transactions CASCADE;
```

---

## Troubleshooting

### "Database not configured"
- Check `.env` file exists
- Verify `SUPABASE_URL` and `SUPABASE_KEY` are set

### "Admin privileges required"
- Create an admin user in database
- Update `admin_headers` fixture with correct credentials

### Tests fail with 401
- Token may be expired
- Check authentication logic in fixtures

---

## Adding New Tests

### Example: Test a new endpoint
```python
def test_my_new_endpoint(client, auth_headers):
    headers, user_id = auth_headers
    
    response = client.get('/my-endpoint', headers=headers)
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['success'] == True
```

### Best Practices
1. Use descriptive test names
2. Test both success and failure cases
3. Verify side effects (e.g., point changes)
4. Clean up after yourself (if possible)
5. Use fixtures for common setup
