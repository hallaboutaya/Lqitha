class NotificationModel {
  final int? id; // INTEGER PRIMARY KEY AUTOINCREMENT
  final String title; // TEXT
  final String message; // TEXT
  final int? relatedPostId; // INTEGER
  final String? type; // TEXT
  final bool isRead; // INTEGER (0/1)
  final String? createdAt; // TEXT
  final int? userId; // INTEGER

  NotificationModel({
    this.id,
    required this.title,
    required this.message,
    this.relatedPostId,
    this.type,
    this.isRead = false,
    this.createdAt,
    this.userId,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'], // INTEGER
      title: map['title'],
      message: map['message'],
      relatedPostId: map['related_post_id'], // INTEGER
      type: map['type'],
      isRead: map['is_read'] == 1, // convert 0/1 → bool
      createdAt: map['created_at'],
      userId: map['user_id'], // INTEGER
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // nullable when inserting
      'title': title,
      'message': message,
      'related_post_id': relatedPostId,
      'type': type,
      'is_read': isRead ? 1 : 0, // convert bool → 0/1
      'created_at': createdAt,
      'user_id': userId,
    };
  }
}
