// lib/models/post.dart
class Post {
  final String id;
  final String userName;
  final String userImage;
  final String timestamp;
  final String type; // "Lost" or "Found"
  final String description;
  final String location;
  final List<String> categories;
  final String imageUrl;
  String status; // "pending", "approved", "rejected"

  Post({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.timestamp,
    required this.type,
    required this.description,
    required this.location,
    required this.categories,
    required this.imageUrl,
    required this.status,
  });
}
