library;
import 'package:flutter/material.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/background_gradient.dart';
import '../../widgets/common/primary_button.dart';
import 'signup/signup_screen.dart';
import 'login/login_screen.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 392),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcomeToLqitha,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(color: AppColors.primaryPurple),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.findAndReportLostItems,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: AppLocalizations.of(context)!.createAccount,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        );
                      },
                      backgroundColor: AppColors.primaryPurple,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryPurple, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        foregroundColor: AppColors.primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(AppLocalizations.of(context)!.signIn),
                    ),
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


