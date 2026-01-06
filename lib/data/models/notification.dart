class NotificationModel {
  final dynamic id; // Can be int (SQLite) or String/UUID (Supabase)
  final String title; // TEXT
  final String message; // TEXT
  final dynamic relatedPostId; // Can be int or String/UUID
  final String? type; // TEXT
  final bool isRead; // BOOLEAN
  final String? createdAt; // TEXT
  final dynamic userId; // Can be int or String/UUID

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
    // Helper to handle both int and String IDs
    dynamic parseId(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      final strValue = value.toString();
      try {
        return int.parse(strValue);
      } catch (e) {
        return strValue; // Keep as string (UUID)
      }
    }

    return NotificationModel(
      id: parseId(map['id']),
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      relatedPostId: parseId(map['related_post_id']),
      type: map['type'],
      isRead: map['is_read'] == 1 || map['is_read'] == true, // Handle both int (SQLite) and bool (Supabase)
      createdAt: map['created_at'],
      userId: parseId(map['user_id']),
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
