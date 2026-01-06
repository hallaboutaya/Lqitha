-- Lqitha Database Schema for Supabase (PostgreSQL)
-- This schema includes all tables for the Lost & Found platform with rewards system

-- ==================== USERS TABLE ====================
CREATE TABLE IF NOT EXISTS users (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    username text NOT NULL,
    email text NOT NULL UNIQUE,
    password text NOT NULL,  -- Bcrypt hashed
    phone_number text,
    photo text,
    role text DEFAULT 'user',  -- 'user' or 'admin'
    points integer DEFAULT 0,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    CONSTRAINT users_pkey PRIMARY KEY (id)
);

-- ==================== FOUND POSTS TABLE ====================
CREATE TABLE IF NOT EXISTS found_posts (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    photo text,
    description text,
    status text DEFAULT 'pending',  -- 'pending', 'approved', 'rejected'
    location text,
    category text,
    created_at timestamptz DEFAULT now(),
    user_id uuid,
    CONSTRAINT found_posts_pkey PRIMARY KEY (id),
    CONSTRAINT found_posts_user_id_fkey FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
);

-- ==================== LOST POSTS TABLE ====================
CREATE TABLE IF NOT EXISTS lost_posts (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    photo text,
    description text,
    status text DEFAULT 'pending',  -- 'pending', 'approved', 'rejected'
    location text,
    category text,
    created_at timestamptz DEFAULT now(),
    user_id uuid,
    CONSTRAINT lost_posts_pkey PRIMARY KEY (id),
    CONSTRAINT lost_posts_user_id_fkey FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
);

-- ==================== NOTIFICATIONS TABLE ====================
CREATE TABLE IF NOT EXISTS notifications (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    title text NOT NULL,
    message text NOT NULL,
    related_post_id uuid,
    type text,  -- 'found_match', 'post_approved', 'post_rejected', 'claim_request'
    is_read boolean DEFAULT false,
    created_at timestamptz DEFAULT now(),
    user_id uuid,
    CONSTRAINT notifications_pkey PRIMARY KEY (id),
    CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
);

-- ==================== CONTACT UNLOCKS TABLE ====================
CREATE TABLE IF NOT EXISTS contact_unlocks (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    post_id uuid NOT NULL,
    post_type text NOT NULL,  -- 'found' or 'lost'
    created_at timestamptz DEFAULT now(),
    CONSTRAINT contact_unlocks_pkey PRIMARY KEY (id),
    CONSTRAINT contact_unlocks_user_id_fkey FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
);

-- ==================== TRUST POINT TRANSACTIONS TABLE ====================
-- Tracks all point changes for the gamification system
CREATE TABLE IF NOT EXISTS trust_point_transactions (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    points integer NOT NULL,  -- Can be positive or negative
    transaction_type text NOT NULL,  -- 'post_created', 'post_approved', 'post_rejected', 'contact_unlocked', 'item_returned'
    description text NOT NULL,
    related_post_id uuid,
    related_post_type text,  -- 'found' or 'lost'
    created_at timestamptz DEFAULT now(),
    CONSTRAINT trust_point_transactions_pkey PRIMARY KEY (id),
    CONSTRAINT trust_point_transactions_user_id_fkey FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
);

-- ==================== INDEXES ====================
-- Improve query performance for common operations

-- Users
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- Found Posts
CREATE INDEX IF NOT EXISTS idx_found_posts_user_id ON found_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_found_posts_status ON found_posts(status);
CREATE INDEX IF NOT EXISTS idx_found_posts_created_at ON found_posts(created_at DESC);

-- Lost Posts
CREATE INDEX IF NOT EXISTS idx_lost_posts_user_id ON lost_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_lost_posts_status ON lost_posts(status);
CREATE INDEX IF NOT EXISTS idx_lost_posts_created_at ON lost_posts(created_at DESC);

-- Notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

-- Contact Unlocks
CREATE INDEX IF NOT EXISTS idx_contact_unlocks_user_id ON contact_unlocks(user_id);
CREATE INDEX IF NOT EXISTS idx_contact_unlocks_post_id ON contact_unlocks(post_id);

-- Trust Point Transactions
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON trust_point_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON trust_point_transactions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON trust_point_transactions(transaction_type);

-- ==================== SEED DATA (Optional) ====================
-- Sample admin user (password: admin123 - hashed with bcrypt)
-- Note: You should change this password in production!

-- INSERT INTO users (username, email, password, role, points) VALUES
-- ('Admin User', 'admin@lqitha.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYzpXHGvzxu', 'admin', 0);

-- Sample regular user (password: user123 - hashed with bcrypt)
-- INSERT INTO users (username, email, password, role, points) VALUES
-- ('John Doe', 'user@lqitha.com', '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 50);
