import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {'title': 'Found a wallet', 'time': '2 hours ago', 'points': '+10'},
      {'title': 'Returned keys', 'time': '1 day ago', 'points': '+5'},
      {'title': 'Unlocked contact', 'time': '2 days ago', 'points': '-20'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...activities.map((a) => _activityTile(a)).toList(),
      ],
    );
  }

  Widget _activityTile(Map<String, String> a) {
    final isPositive = a['points']!.contains('+');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a['title']!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(a['time']!, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(
            a['points']!,
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
