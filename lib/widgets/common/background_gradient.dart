/// Decorative gradient background widget with floating circular elements.
/// 
/// Wraps page content with a beautiful gradient background that transitions
/// from light purple to light orange. Includes decorative circles for visual interest.
/// 
/// Used on Founds and Losts pages to match the Figma design aesthetic.
library;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class BackgroundGradient extends StatelessWidget {
  /// The child widget to display over the gradient background
  final Widget child;

  const BackgroundGradient({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [
            AppColors.backgroundStart,
            AppColors.backgroundMid,
            AppColors.backgroundEnd,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            left: 93.84,
            top: 0,
            child: Opacity(
              opacity: 0.07,
              child: Container(
                width: 500,
                height: 500,
                decoration: ShapeDecoration(
                  color: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999999),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -218.47,
            top: 1049.84,
            child: Opacity(
              opacity: 0.07,
              child: Container(
                width: 500,
                height: 500,
                decoration: ShapeDecoration(
                  color: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999999),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 35.37,
            top: 688.79,
            child: Opacity(
              opacity: 0.05,
              child: Container(
                width: 300,
                height: 300,
                decoration: ShapeDecoration(
                  color: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999999),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 176.61,
            top: 71.05,
            child: Opacity(
              opacity: 0.10,
              child: Container(
                width: 113.84,
                height: 113.84,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1.17,
                      color: AppColors.primaryPurple,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 117.67,
            top: 1851.02,
            child: Opacity(
              opacity: 0.10,
              child: Container(
                width: 94.87,
                height: 94.87,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1.17,
                      color: AppColors.primaryOrange,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          // Main content
          child,
        ],
      ),
    );
  }
}

