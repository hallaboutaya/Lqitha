// lib/widgets/admin/post_card.dart
import 'package:flutter/material.dart';
import '../../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PostCard({
    super.key,
    required this.post,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              post.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(post.userImage),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: const Icon(Icons.person, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            post.timestamp,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Type tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: post.type == 'Lost'
                        ? Colors.red[50]
                        : Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    post.type,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: post.type == 'Lost'
                          ? Colors.red[700]
                          : Colors.green[700],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  post.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),

                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.red[400]),
                    const SizedBox(width: 4),
                    Text(
                      post.location,
                      style: TextStyle(fontSize: 12, color: Colors.red[400]),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Category chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: post.categories.map((category) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Action buttons (only show for pending posts)
                if (post.status == 'pending') ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onApprove,
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onReject,
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
