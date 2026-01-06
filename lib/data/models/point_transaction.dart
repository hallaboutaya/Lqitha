class PointTransaction {
  final String id;
  final String userId;
  final int points;
  final String transactionType;
  final String description;
  final String? relatedPostId;
  final String? relatedPostType;
  final String createdAt;

  PointTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.transactionType,
    required this.description,
    this.relatedPostId,
    this.relatedPostType,
    required this.createdAt,
  });

  factory PointTransaction.fromMap(Map<String, dynamic> map) {
    return PointTransaction(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      points: map['points'] ?? 0,
      transactionType: map['transaction_type'] ?? '',
      description: map['description'] ?? '',
      relatedPostId: map['related_post_id']?.toString(),
      relatedPostType: map['related_post_type'],
      createdAt: map['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'points': points,
      'transaction_type': transactionType,
      'description': description,
      'related_post_id': relatedPostId,
      'related_post_type': relatedPostType,
      'created_at': createdAt,
    };
  }
}
