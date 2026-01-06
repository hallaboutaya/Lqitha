library;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/inputs/text_input.dart';
import '../../../../widgets/common/primary_button.dart';
import '../../../../cubits/auth/auth_cubit.dart';
import '../../../../cubits/auth/auth_state.dart';
import '../../../../services/service_locator.dart';
import '../../../main_navigation.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    print('🔵 Signup: Submit button pressed');
    final form = _formKey.currentState;
    if (form == null) {
      print('❌ Signup: Form key is null');
      return;
    }
    
    if (!form.validate()) {
      print('❌ Signup: Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('✅ Signup: Form validated, calling AuthCubit.signup');
    print('👤 Username: ${_nameController.text.trim()}');
    print('📧 Email: ${_emailController.text.trim()}');
    
    // Trigger signup via AuthCubit
    context.read<AuthCubit>().signup(
      username: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    print('🔄 Signup: AuthState changed: ${state.runtimeType}');
    
    if (state is AuthError) {
      print('❌ Signup: Error state - ${state.message}');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } else if (state is AuthAuthenticated) {
      print('✅ Signup: Authenticated - navigating to main');
      // Navigate to main screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 0)),
        (route) => false,
      );
    } else if (state is AuthLoading) {
      print('⏳ Signup: Loading state');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: _handleAuthState,
        builder: (context, state) {
          final bool isLoading = state is AuthLoading;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppLocalizations.of(context)!.fullName, style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: const Color(0xFF0A0A0A))),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _nameController,
                  hintText: 'John Doe',
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().length < 2) ? AppLocalizations.of(context)!.enterFullName : null,
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.email, style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: const Color(0xFF0A0A0A))),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _emailController,
                  hintText: 'you@email.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    final l10n = AppLocalizations.of(context)!;
                    if (v == null || v.isEmpty) return l10n.enterYourEmail;
                    final email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    return email.hasMatch(v) ? null : l10n.enterValidEmail;
                  },
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.phoneNumber, style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: const Color(0xFF0A0A0A))),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _phoneController,
                  hintText: '+213 555 1234',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    final l10n = AppLocalizations.of(context)!;
                    if (v == null || v.trim().isEmpty) return l10n.enterPhoneNumber;
                    if (v.trim().length < 10) return l10n.enterValidPhoneNumber;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.password, style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: const Color(0xFF0A0A0A))),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (v) => (v == null || v.length < 6) ? AppLocalizations.of(context)!.useAtLeast6Characters : null,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: isLoading 
                    ? 'Creating account...' 
                    : AppLocalizations.of(context)!.createAccount,
                  onPressed: isLoading ? null : () {
                    print('🔵 Signup button pressed!');
                    _onSubmit(context);
                  },
                  backgroundColor: AppColors.primaryPurple,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
