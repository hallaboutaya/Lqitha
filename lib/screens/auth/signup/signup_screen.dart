library;
import 'package:flutter/material.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/common/background_gradient.dart';
import 'widgets/signup_header.dart';
import 'widgets/signup_form.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static const String routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 392),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SignupHeader(),
                    const SizedBox(height: 32),
                    const SignupForm(),
                    const SizedBox(height: 16),
                    _AlreadyHaveAccount(onTapSignin: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlreadyHaveAccount extends StatelessWidget {
  final VoidCallback onTapSignin;
  const _AlreadyHaveAccount({required this.onTapSignin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.alreadyHaveAccount,
          style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTapSignin,
          child: Text(
            AppLocalizations.of(context)!.signIn,
            style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryPurple),
          ),
        ),
      ],
    );
  }
}


