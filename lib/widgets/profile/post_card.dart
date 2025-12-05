import 'package:flutter/material.dart';
import '../../models/profile_post_model.dart';

class PostCard extends StatelessWidget {
  final ProfilePost post;

  const PostCard({super.key, required this.post});

  Color _getStatusColor() {
    switch (post.status) {
      case 'validated':
        return Colors.green;
      case 'on_hold':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (post.status) {
      case 'validated':
        return 'Validated';
      case 'on_hold':
        return 'Pending Review';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    post.location,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (post.note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      post.note!,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
