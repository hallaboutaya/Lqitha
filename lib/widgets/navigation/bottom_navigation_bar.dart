/// Custom bottom navigation bar matching Figma design.
/// 
/// Displays four navigation tabs:
/// - Founds (index 0) - Found items page
/// - Losts (index 1) - Lost items page
/// - Notifications (index 2) - Alerts & unlocks
/// - Profile (index 3) - User profile page
/// 
/// Active tab is highlighted with orange background and white text.
/// Includes a small purple dot indicator above active tab icons.
/// 
/// This is the PRIMARY navigation mechanism for the app - users switch
/// between pages by tapping these tabs.
library;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  /// Currently active tab index (0-3)
  final int currentIndex;
  
  /// Callback fired when user taps a navigation item
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 1.17),
      decoration: ShapeDecoration(
        color: AppColors.bottomNavBackground,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1.17,
            color: AppColors.bottomNavBorder,
          ),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowPurpleSubtle,
            blurRadius: 16,
            offset: Offset(0, -2),
            spreadRadius: 0,
          )
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.search,
                label: 'Founds',
                index: 0,
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _buildNavItem(
                icon: Icons.visibility_off,
                label: 'Losts',
                index: 1,
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _buildNavItem(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                index: 2,
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                index: 3,
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: isActive ? AppColors.primaryOrange : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: isActive
              ? const [
                  BoxShadow(
                    color: AppColors.shadowBlack,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: AppColors.shadowBlack,
                    blurRadius: 15,
                    offset: Offset(0, 10),
                    spreadRadius: -3,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: ShapeDecoration(
                  color: AppColors.accentPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            Icon(
              icon,
              size: 24,
              color: isActive ? Colors.white : AppColors.textLight,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isActive
                  ? AppTextStyles.bottomNavActive
                  : AppTextStyles.bottomNavInactive,
            ),
          ],
        ),
      ),
    );
  }
}

