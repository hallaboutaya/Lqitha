import 'package:flutter/material.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

/// Filter dialog for found/lost items
/// Allows filtering by category
class FilterDialog extends StatefulWidget {
  final String? selectedCategory;
  final Function(String?) onApplyFilter;

  const FilterDialog({
    super.key,
    this.selectedCategory,
    required this.onApplyFilter,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _selectedCategory;

  // Common categories for items
  final List<String> _categories = [
    'All',
    'Wallet',
    'Phone',
    'Keys',
    'Backpack',
    'ID Card',
    'Laptop',
    'Jewelry',
    'Clothing',
    'Electronics',
    'Documents',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filter by Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == 'All' 
                      ? _selectedCategory == null 
                      : _selectedCategory == category;
                  
                  return ListTile(
                    title: Text(category),
                    leading: Radio<String?>(
                      value: category == 'All' ? null : category,
                      groupValue: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      activeColor: AppColors.primaryPurple,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCategory = category == 'All' ? null : category;
                      });
                    },
                    tileColor: isSelected 
                        ? AppColors.primaryPurple.withOpacity(0.1) 
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilter(_selectedCategory);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
