class User {
  final dynamic id; // Can be int (SQLite) or String/UUID (Supabase)
  final String username; // TEXT
  final String email; // TEXT
  final String password; // TEXT
  final String? phoneNumber; // TEXT
  final String? photo; // TEXT
  final String role; // TEXT
  final int points; // INTEGER
  final String? createdAt; // TEXT
  final String? updatedAt; // TEXT

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.photo,
    this.role = 'user',
    this.points = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    // Handle both int IDs (SQLite) and String/UUID IDs (Supabase)
    dynamic userId = map['id'];
    if (userId != null) {
      if (userId is int) {
        // SQLite integer ID
        userId = userId;
      } else if (userId is String) {
        // Try to parse as int (for numeric strings), otherwise keep as String (UUID)
        try {
          userId = int.parse(userId);
        } catch (e) {
          // Keep as String (UUID from Supabase)
          userId = userId;
        }
      }
    }
    
    return User(
      id: userId,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phone_number'],
      photo: map['photo'],
      role: map['role'] ?? 'user',
      points: map['points'] ?? 0,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'photo': photo,
      'role': role,
      'points': points,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
    
    // Only include id if it's not null (for updates)
    if (id != null) {
      map['id'] = id;
    }
    
    return map;
  }
}
