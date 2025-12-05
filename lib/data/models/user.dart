class User {
  final int? id; // INTEGER PRIMARY KEY AUTOINCREMENT
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
    return User(
      id: map['id'], // INTEGER
      username: map['username'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phone_number'],
      photo: map['photo'],
      role: map['role'],
      points: map['points'] ?? 0,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // nullable when inserting
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
  }
}
