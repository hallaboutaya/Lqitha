import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _StatItem(icon: Icons.inventory_2_outlined, count: 8, label: 'Items Found'),
        _StatItem(icon: Icons.check_circle_outline, count: 5, label: 'Items Returned'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const _StatItem({required this.icon, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 30),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
