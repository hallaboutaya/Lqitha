class LostPost {
  final int? id;
  final String? photo;
  final String? description;
  final String status;
  final String? location;
  final String? category;
  final String? createdAt;
  final int? userId;
  String? username;
  String? userPhoto;

  LostPost({
    this.id,
    this.photo,
    this.description,
    this.status = 'pending',
    this.location,
    this.category,
    this.createdAt,
    this.userId,
    this.username,
    this.userPhoto,
  });

  factory LostPost.fromMap(Map<String, dynamic> map) {
    return LostPost(
      id: map['id'],
      photo: map['photo'],
      description: map['description'],
      status: map['status'],
      location: map['location'],
      category: map['category'],
      createdAt: map['created_at'],
      userId: map['user_id'],
      username: map['username'],
      userPhoto: map['user_photo'],
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
