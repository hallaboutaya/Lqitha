import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final String currentTab;
  final Function(String) onTabChanged;

  const TabSelector({
    Key? key,
    required this.currentTab,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTab('pending', 'Pending', null),
        const SizedBox(width: 16),
        _buildTab('approved', 'Approved', null),
        const SizedBox(width: 16),
        _buildTab('rejected', 'Rejected', null),
      ],
    );
  }

  Widget _buildTab(String value, String label, int? count) {
    final isSelected = currentTab == value;
    return GestureDetector(
      onTap: () => onTabChanged(value),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 4),
                Text(
                  '($count)',
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 60,
            color: isSelected ? Colors.black : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
