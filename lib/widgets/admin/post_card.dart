import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hopefully_last/l10n/app_localizations.dart';

class PostCard extends StatelessWidget {
  final dynamic id;
  final String type;
  final String? photo;
  final String? username;
  final String? userPhoto;
  final String? createdAt;
  final String? postType;
  final String? description;
  final String? location;
  final String? category;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PostCard({
    Key? key,
    required this.id,
    required this.type,
    this.photo,
    this.username,
    this.userPhoto,
    this.createdAt,
    this.postType,
    this.description,
    this.location,
    this.category,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (photo != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                photo!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username ?? 'Unknown User',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _formatTime(createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: type == 'lost' ? Colors.red[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type == 'lost' ? 'Lost' : 'Found',
                    style: TextStyle(
                      fontSize: 12,
                      color: type == 'lost' ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(description ?? '', style: const TextStyle(fontSize: 14)),
                if (location != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.red[400]),
                      const SizedBox(width: 4),
                      Text(
                        location!,
                        style: TextStyle(fontSize: 12, color: Colors.red[400]),
                      ),
                    ],
                  ),
                ],
                if (category != null) ...[
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: [_buildTag(category!)]),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onApprove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check, size: 18),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.approve),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onReject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.close, size: 18),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.reject),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  String _formatTime(String? isoTime) {
    if (isoTime == null) return '';
    try {
      final date = DateTime.parse(isoTime);
      return timeago.format(date, locale: 'en_short');
    } catch (e) {
      return '';
    }
  }
}
