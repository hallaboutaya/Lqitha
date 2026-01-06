class ContactUnlock {
  final String id;
  final String userId;
  final String postId;
  final String postType; // 'found' or 'lost'
  final String createdAt;

  ContactUnlock({
    required this.id,
    required this.userId,
    required this.postId,
    required this.postType,
    required this.createdAt,
  });

  factory ContactUnlock.fromMap(Map<String, dynamic> map) {
    return ContactUnlock(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      postId: map['post_id'] ?? '',
      postType: map['post_type'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'post_type': postType,
      'created_at': createdAt,
    };
  }
}
