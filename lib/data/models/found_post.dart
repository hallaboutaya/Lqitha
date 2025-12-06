class FoundPost {
  final int? id; // INTEGER PRIMARY KEY AUTOINCREMENT => nullable when creating
  final String? photo; // TEXT
  final String? description; // TEXT
  final String status; // TEXT (default 'pending')
  final String? location; // TEXT
  final String? category; // TEXT
  final String? createdAt; // TEXT (ISO date)
  final int? userId; // INTEGER (FK to users.id)

  FoundPost({
    this.id,
    this.photo,
    this.description,
    this.status = 'pending',
    this.location,
    this.category,
    this.createdAt,
    this.userId,
  });

  factory FoundPost.fromMap(Map<String, dynamic> map) {
    return FoundPost(
      id: map['id'] is int ? map['id'] : (map['id'] != null ? int.parse(map['id'].toString()) : null),
      photo: map['photo'],
      description: map['description'],
      status: map['status'],
      location: map['location'],
      category: map['category'],
      createdAt: map['created_at'],
      userId: map['user_id'] is int ? map['user_id'] : (map['user_id'] != null ? int.parse(map['user_id'].toString()) : null),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // nullable when inserting
      'photo': photo,
      'description': description,
      'status': status,
      'location': location,
      'category': category,
      'created_at': createdAt,
      'user_id': userId,
    };
  }
}
