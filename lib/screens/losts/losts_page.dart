/// Lost Items page displaying list of items that have been lost.
/// 
/// Features:
/// - Page header with orange accent bar
/// - Search bar for filtering items by description or location
/// - List of LostItemCard widgets showing lost items
/// - Floating action button (+) to report a new lost item
/// 
/// This is the second tab (index 1) in the bottom navigation.
/// Items are filtered in real-time as the user types in the search bar.
library;
import 'package:flutter/material.dart';
import '../../widgets/inputs/search_bar.dart';
import '../../widgets/cards/lost_item_card.dart';
import '../../widgets/common/background_gradient.dart';
import '../../widgets/popups/popup_lost_item.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LostsPage extends StatefulWidget {
  /// Current bottom navigation index (passed from MainNavigation)
  final int currentIndex;
  
  /// Callback to navigate to other pages (passed from MainNavigation)
  final Function(int) onNavTap;

  const LostsPage({
    super.key,
    this.currentIndex = 1,
    required this.onNavTap,
  });

  @override
  State<LostsPage> createState() => _LostsPageState();
}

class _LostsPageState extends State<LostsPage> {
  /// Current search query for filtering lost items
  String _searchQuery = '';

  final List<Map<String, dynamic>> _losts = [
    {
      'userName': 'Karim Meziane',
      'timeAgo': 'Yesterday',
      'description': 'Lost my brown leather wallet with ID cards and bank cards. Last seen at the shopping mall.',
      'location': 'Bab Ezzouar Mall',
      'tags': ['Wallet', 'ID'],
      'imageUrl': 'https://placehold.co/294x256',
      'borderColor': AppColors.primaryOrange,
      'hasReward': true,
    },
    {
      'userName': 'Lina Hamdi',
      'timeAgo': '2 days ago',
      'description': 'Silver iPhone 13 with a clear case. Lost at the beach yesterday afternoon.',
      'location': 'Sidi Fredj Beach',
      'tags': ['Phone', 'Electronics'],
      'imageUrl': 'https://placehold.co/294x256',
      'borderColor': AppColors.primaryPurple,
      'hasReward': false,
    },
    {
      'userName': 'Rayan Boukhari',
      'timeAgo': '3 days ago',
      'description': 'Lost my prescription glasses in a black case. Very important, I can barely see without them!',
      'location': 'Grande Poste',
      'tags': ['Glasses', 'Medical'],
      'imageUrl': 'https://placehold.co/294x256',
      'borderColor': AppColors.primaryOrange,
      'hasReward': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredLosts = _losts.where((item) {
      final matchesSearch = item['description']!
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          item['location']!
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lost Items',
                            style: AppTextStyles.pageTitle.copyWith(
                              color: AppColors.primaryOrange,
                            ),
                          ),
                          Text(
                            'Help people find their lost belongings',
                            style: AppTextStyles.subtitle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomSearchBar(
                  hintText: 'Search lost items...',
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  onFilterTap: () {
                    // Handle filter tap
                  },
                ),
              ),
              const SizedBox(height: 16),
              // List of Lost Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredLosts.length,
                  itemBuilder: (context, index) {
                    final item = filteredLosts[index];
                    return LostItemCard(
                      userName: item['userName'] as String,
                      timeAgo: item['timeAgo'] as String,
                      description: item['description'] as String,
                      location: item['location'] as String,
                      tags: (item['tags'] as List).map((e) => e.toString()).toList(),
                      imageUrl: item['imageUrl'] as String,
                      borderColor: item['borderColor'] as Color,
                      hasReward: item['hasReward'] as bool,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button for Adding Lost Item
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: ShapeDecoration(
          color: AppColors.locationBadgeBgOrange,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.27,
              color: Color(0x4CFF6B35),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19FF6B35),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 12,
                height: 12,
                decoration: ShapeDecoration(
                  color: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: AppColors.shadowBlack,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: AppColors.shadowBlack,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                      spreadRadius: -1,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: IconButton(
                icon: const Icon(Icons.add, color: AppColors.primaryOrange),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const LostItemPopup(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

