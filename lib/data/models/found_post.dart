class FoundPost {
  final String id;
  final String? photo;
  final String? description;
  final String status;
  final String? location;
  final String? category;
  final String? createdAt;
  final String? userId;

  FoundPost({
    required this.id,
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
      id: map['id'],
      photo: map['photo'],
      description: map['description'],
      status: map['status'],
      location: map['location'],
      category: map['category'],
      createdAt: map['created_at'],
      userId: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
