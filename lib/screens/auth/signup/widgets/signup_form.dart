library;
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/inputs/text_input.dart';
import '../../../../widgets/common/primary_button.dart';
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
  final TextEditingController _passwordController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      // TODO: Hook up to auth service
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 0)),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Full Name', style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: const Color(0xFF0A0A0A))),
          const SizedBox(height: 8),
          AuthTextField(
            controller: _nameController,
            hintText: 'John Doe',
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.trim().length < 2) ? 'Enter your full name' : null,
          ),
          const SizedBox(height: 16),
          Text('Email', style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: const Color(0xFF0A0A0A))),
          const SizedBox(height: 8),
          AuthTextField(
            controller: _emailController,
            hintText: 'you@email.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter your email';
              final email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              return email.hasMatch(v) ? null : 'Enter a valid email';
            },
          ),
          const SizedBox(height: 16),
          Text('Password', style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: const Color(0xFF0A0A0A))),
          const SizedBox(height: 8),
          AuthTextField(
            controller: _passwordController,
            hintText: '••••••••',
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: (v) => (v == null || v.length < 6) ? 'Use at least 6 characters' : null,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Create Account',
            onPressed: _isSubmitting ? null : _onSubmit,
            backgroundColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }
}


