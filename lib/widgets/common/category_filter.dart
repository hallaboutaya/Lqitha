/// Horizontal scrollable category filter widget.
/// 
/// Displays a list of category options as selectable chips.
/// Used for filtering items by category (e.g., "All", "Electronics", "Documents").
/// 
/// Currently unused but kept for future implementation of category filtering.
/// Note: This widget uses old styling. Should be updated to match Figma design
/// with proper colors from AppColors when implemented.
library;
import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  /// List of category names to display
  final List<String> categories;
  
  /// Currently selected category
  final String selected;
  
  /// Callback function called when a category is tapped
  final ValueChanged<String> onSelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      // Horizontal scrollable list of category chips
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;
          
          // Each category is a tappable chip
          return GestureDetector(
            onTap: () => onSelected(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                // Selected category has green background, unselected is gray
                // TODO: Update to use AppColors when implementing
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: TextStyle(
                  // Selected text is white, unselected is dark
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
