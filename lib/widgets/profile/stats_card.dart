import 'package:flutter/material.dart';
import '../../data/databases/db_helper.dart';

class StatsCard extends StatefulWidget {
  final int userId;
  
  const StatsCard({super.key, required this.userId});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  int _foundItemsCount = 0;
  int _lostItemsCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final db = await DBHelper.getDatabase();
      
      // Count APPROVED found posts by this user
      final foundResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM found_posts WHERE user_id = ? AND status = ?',
        [widget.userId, 'approved'],
      );
      
      // Count APPROVED lost posts by this user
      final lostResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM lost_posts WHERE user_id = ? AND status = ?',
        [widget.userId, 'approved'],
      );
      
      setState(() {
        _foundItemsCount = (foundResult.first['count'] as int?) ?? 0;
        _lostItemsCount = (lostResult.first['count'] as int?) ?? 0;
        _loading = false;
      });
    } catch (e) {
      print('Error loading stats: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          icon: Icons.inventory_2_outlined,
          count: _foundItemsCount,
          label: 'Items Found',
        ),
        _StatItem(
          icon: Icons.search_outlined,
          count: _lostItemsCount,
          label: 'Items Lost',
        ),
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
