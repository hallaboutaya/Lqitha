import 'package:flutter/material.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../data/repositories/found_repository.dart';
import '../../data/repositories/lost_repository.dart';
import '../../services/service_locator.dart';

class StatsCard extends StatefulWidget {
  final dynamic userId; // Can be int (SQLite) or String (UUID from Supabase)
  
  const StatsCard({super.key, required this.userId});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  int _foundItemsCount = 0;
  int _lostItemsCount = 0;
  bool _loading = true;
  
  final FoundRepository _foundRepository = getIt<FoundRepository>();
  final LostRepository _lostRepository = getIt<LostRepository>();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      // Get all approved posts for this user using repositories
      final foundPosts = await _foundRepository.getPostsByUserId(widget.userId, status: 'approved');
      final lostPosts = await _lostRepository.getPostsByUserId(widget.userId, status: 'approved');
      
      setState(() {
        _foundItemsCount = foundPosts.length;
        _lostItemsCount = lostPosts.length;
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
    
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          icon: Icons.inventory_2_outlined,
          count: _foundItemsCount,
          label: l10n.itemsFound,
        ),
        _StatItem(
          icon: Icons.search_outlined,
          count: _lostItemsCount,
          label: l10n.itemsLost,
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
