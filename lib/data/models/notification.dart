class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String? relatedPostId;
  final String? type;
  final bool isRead;
  final String? createdAt;
  final String? userId;

  NotificationModel({
    required this.id,
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
      id: map['id'],
      title: map['title'],
      message: map['message'],
      relatedPostId: map['related_post_id'],
      type: map['type'],
      isRead: map['is_read'] == 1,
      createdAt: map['created_at'],
      userId: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'related_post_id': relatedPostId,
      'type': type,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt,
      'user_id': userId,
    };
  }
}
