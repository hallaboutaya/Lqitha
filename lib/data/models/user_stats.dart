class UserStats {
  final dynamic userId;
  final String username;
  final String? photo;
  final int points;
  final int totalPosts;
  final int approvedPosts;
  final int rejectedPosts;
  final int resolvedPosts;

  UserStats({
    required this.userId,
    required this.username,
    this.photo,
    required this.points,
    required this.totalPosts,
    required this.approvedPosts,
    required this.rejectedPosts,
    required this.resolvedPosts,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      userId: map['user_id'] ?? map['id'],
      username: map['username'] ?? 'Unknown',
      photo: map['photo'],
      points: map['points'] ?? 0,
      totalPosts: map['total_posts'] ?? 0,
      approvedPosts: map['approved_posts'] ?? 0,
      rejectedPosts: map['rejected_posts'] ?? 0,
      resolvedPosts: map['resolved_posts'] ?? 0,
    );
  }

  double get successRate {
    if (totalPosts == 0) return 0.0;
    return (approvedPosts + resolvedPosts) / totalPosts;
  }
}
