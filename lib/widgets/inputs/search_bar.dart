/// Custom search bar widget with search input and filter button.
/// Displays a text input field with search icon on the left, and an optional
/// filter button on the right. Styled to match Figma design with purple borders and shadows.
/// Used on Founds and Losts pages for searching items.
library;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomSearchBar extends StatelessWidget {
  /// Placeholder text shown when search field is empty
  final String hintText;
  
  /// Callback fired when user types in the search field
  final ValueChanged<String>? onChanged;
  
  /// Callback fired when user taps the filter button
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Input
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: ShapeDecoration(
              color: AppColors.cardBackground,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1.17,
                  color: AppColors.borderPurple,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: const [
                BoxShadow(
                  color: AppColors.shadowPurple,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                  spreadRadius: 0,
                )
              ],
            ),
            child: TextField(
              onChanged: onChanged,
              style: AppTextStyles.searchHint.copyWith(color: AppColors.textLight),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.searchHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Filter Button
        InkWell(
          onTap: onFilterTap,
          child: Container(
            width: 54.31,
            height: 48,
            decoration: ShapeDecoration(
              color: AppColors.cardBackground,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1.17,
                  color: AppColors.borderPurple,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: const [
                BoxShadow(
                  color: AppColors.shadowPurple,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                  spreadRadius: 0,
                )
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.tune,
                size: 20,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
