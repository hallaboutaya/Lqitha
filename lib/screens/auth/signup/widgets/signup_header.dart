library;
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _IconBadge(),
        const SizedBox(height: 24),
        Text(
          'Create account',
          textAlign: TextAlign.center,
          style: AppTextStyles.pageTitle.copyWith(color: AppColors.primaryPurple, fontSize: 36),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DividerLine(),
            const SizedBox(width: 8),
            Text(
              'Join the LQitha community',
              style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: 8),
            _DividerLine(),
          ],
        ),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 1,
      color: const Color(0xFFD1D5DC),
    );
  }
}

class _IconBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: AppColors.primaryPurple.withOpacity(0.10),
          ),
        ),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white.withOpacity(0.80),
            border: Border.all(color: Colors.white.withOpacity(0.60), width: 1.27),
            boxShadow: const [
              BoxShadow(color: AppColors.shadowPurpleSubtle, blurRadius: 40, offset: Offset(0, 12)),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.person_add_alt_1, color: Colors.white),
              ),
              Positioned(
                right: 12,
                top: 8,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}


