class FoundPost {
  final dynamic id; // Can be int (SQLite) or String/UUID (Supabase)
  final String? photo; // TEXT
  final String? description; // TEXT
  final String status; // TEXT (default 'pending')
  final String? location; // TEXT
  final String? category; // TEXT
  final String? createdAt; // TEXT (ISO date)
  final dynamic userId; // Can be int (SQLite) or String/UUID (Supabase)

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
    // Handle both int IDs (SQLite) and String/UUID IDs (Supabase)
    dynamic postId = map['id'];
    if (postId != null && postId is String) {
      // Try to parse as int (for numeric strings), otherwise keep as String (UUID)
      try {
        postId = int.parse(postId);
      } catch (e) {
        // Keep as String (UUID from Supabase)
        postId = postId;
      }
    }
    
    dynamic userId = map['user_id'];
    if (userId != null && userId is String) {
      // Try to parse as int (for numeric strings), otherwise keep as String (UUID)
      try {
        userId = int.parse(userId);
      } catch (e) {
        // Keep as String (UUID from Supabase)
        userId = userId;
      }
    }
    
    return FoundPost(
      id: postId,
      photo: map['photo'],
      description: map['description'],
      status: map['status'] ?? 'pending',
      location: map['location'],
      category: map['category'],
      createdAt: map['created_at'],
      userId: userId,
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
