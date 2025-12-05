/// Page header component with accent bar, title, and subtitle.
/// 
/// Displays a colored accent bar on the left, followed by a large title
/// and smaller subtitle. Used at the top of pages like Founds and Losts.
/// 
/// The accent bar color should match the page theme (purple for founds, orange for losts).
library;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class PageHeader extends StatelessWidget {
  /// Main page title (e.g., "Found Items", "Lost Items")
  final String title;
  
  /// Subtitle providing additional context or description
  final String subtitle;
  
  /// Color of the accent bar (defaults to purple if not specified)
  final Color accentColor;  // ✅ ADD THIS

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.accentColor = AppColors.primaryPurple,  // ✅ ADD THIS with default value
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Accent Bar
        Container(
          width: 4,
          height: 48,
          decoration: ShapeDecoration(
            color: accentColor,  // ✅ CHANGE THIS from AppColors.primaryPurple to accentColor
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Title and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.pageTitle,
              ),
              Text(
                subtitle,
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}