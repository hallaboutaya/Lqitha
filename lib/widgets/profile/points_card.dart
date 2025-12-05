import 'package:flutter/material.dart';



class PointsCard extends StatelessWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events_outlined, color: Colors.white),
                  SizedBox(width: 6),
                  Text('Total Points', style: TextStyle(color: Colors.white)),
                ],
              ),
              Text('Active', style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '125',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Keep helping others to earn more!',
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {},
            child: const Text('Reclaim My Points'),
          )
        ],
      ),
    );
  }
}
