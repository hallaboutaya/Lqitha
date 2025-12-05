library;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ?? AppColors.primaryOrange;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          shadowColor: AppColors.shadowBlack,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.buttonText.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


