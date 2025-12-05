/// Found Items page displaying list of items that have been found.
/// 
/// Features:
/// - Page header with purple accent bar
/// - Search bar for filtering items by description or location
/// - List of FoundItemCard widgets showing found items
/// - Floating action button (+) to report a new found item
/// 
/// This is the first tab (index 0) in the bottom navigation.
/// Items are filtered in real-time as the user types in the search bar.
library;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/inputs/search_bar.dart';
import '../../widgets/cards/found_item_card.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/background_gradient.dart';
import '../../widgets/popups/popup_found_item.dart';
import '../../theme/app_colors.dart';

class FoundsPage extends StatefulWidget {
  /// Current bottom navigation index (passed from MainNavigation)
  final int currentIndex;
  
  /// Callback to navigate to other pages (passed from MainNavigation)
  final Function(int) onNavTap;

  const FoundsPage({
    super.key,
    this.currentIndex = 0,
    required this.onNavTap,
  });

  @override
  State<FoundsPage> createState() => _FoundsPageState();
}

class _FoundsPageState extends State<FoundsPage> {
  /// Current search query for filtering found items
  String _searchQuery = '';

  final List<Map<String, dynamic>> _founds = [
    {
      'userName': 'Sarah Johnson',
      'timeAgo': '2 hours ago',
      'description': 'Found a black leather wallet near the metro station. Contains some cards and cash.',
      'location': 'Algiers Metro',
      'tags': ['Wallet', 'Cards'],
      'imageUrl': 'https://placehold.co/301x256',
      'borderColor': AppColors.primaryPurple,
    },
    {
      'userName': 'Ahmed Benali',
      'timeAgo': '5 hours ago',
      'description': 'Set of keys with a red keychain found at the university parking lot.',
      'location': 'University Campus',
      'tags': ['Keys', 'Keychain'],
      'imageUrl': 'https://placehold.co/301x256',
      'borderColor': AppColors.primaryOrange,
    },
    {
      'userName': 'Amina Kader',
      'timeAgo': '1 day ago',
      'description': 'Blue backpack found at the coffee shop. Contains books and a laptop.',
      'location': 'Café Central',
      'tags': ['Backpack', 'Electronics'],
      'imageUrl': 'https://placehold.co/301x256',
      'borderColor': AppColors.primaryPurple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFounds = _founds.where((item) {
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
                child: PageHeader(
                  title: AppLocalizations.of(context)!.foundItems,
                  subtitle: AppLocalizations.of(context)!.helpReuniteItems,
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomSearchBar(
                  hintText: AppLocalizations.of(context)!.searchItemsTagsLocations,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  onFilterTap: () {
                    // Handle filter tap
                  },
                ),
              ),
              const SizedBox(height: 16),
              // List of Found Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredFounds.length,
                  itemBuilder: (context, index) {
                    final item = filteredFounds[index];
                    return FoundItemCard(
                      userName: item['userName'] as String,
                      timeAgo: item['timeAgo'] as String,
                      description: item['description'] as String,
                      location: item['location'] as String,
                      tags: (item['tags'] as List).map((e) => e.toString()).toList(),
                      imageUrl: item['imageUrl'] as String,
                      borderColor: item['borderColor'] as Color,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button for Adding Found Item
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: ShapeDecoration(
          color: AppColors.locationBadgeBg,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.17,
              color: AppColors.borderPurpleSolid,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: AppColors.shadowPurpleLight,
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 46.83,
              top: 5.17,
              child: Container(
                width: 12,
                height: 12,
                decoration: ShapeDecoration(
                  color: AppColors.primaryOrange,
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
                icon: const Icon(Icons.add, color: AppColors.primaryPurple),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const FoundItemPopup(),
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
