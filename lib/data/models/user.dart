class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? photo;
  final String role;
  final int points;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
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
      id: map['id'],
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
      'id': id,
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
