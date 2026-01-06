/// Main navigation wrapper that manages page switching via bottom navigation bar.
/// 
/// This widget uses a PageView to enable smooth transitions between pages:
/// - Index 0: Founds Page (found items)
/// - Index 1: Losts Page (lost items)
/// - Index 2: Notifications Page (unlock contacts, status updates)
/// - Index 3: Profile Page (stats & activity)
/// 
/// The bottom navigation bar is managed here and appears on all pages.
/// When a user taps a tab, it smoothly animates to the corresponding page.
library;
import 'package:flutter/material.dart';
import '../widgets/navigation/bottom_navigation_bar.dart';
import 'founds/founds_page.dart';
import 'losts/losts_page.dart';
import 'notifications/notifications_page.dart';
import 'profile/main_profile.dart';

class MainNavigation extends StatefulWidget {
  /// Initial page index to display when the app starts (0 = Founds, 1 = Losts, etc.)
  const MainNavigation({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  /// Current active tab index (0-3)
  late int _currentIndex;
  
  /// Controller for managing page transitions in PageView
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Initialize PageController with the starting page
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    // Clean up PageController to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  /// Called when user taps on a bottom navigation item
  /// Updates the current index and animates to the selected page
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Smoothly animate to the selected page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView allows swiping between pages and programmatic navigation
      body: PageView(
        controller: _pageController,
        // Update index when user swipes between pages
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // Founds page - displays found items
          FoundsPage(currentIndex: _currentIndex, onNavTap: _onItemTapped),
          // Losts page - displays lost items
          LostsPage(currentIndex: _currentIndex, onNavTap: _onItemTapped),
          // Notifications page - reload when visible
          NotificationsPage(
            isVisible: _currentIndex == 2,
          ),
          // Profile page
          const MainProfilePage(),
        ],
      ),
      // Bottom navigation bar appears on all pages and manages navigation
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}