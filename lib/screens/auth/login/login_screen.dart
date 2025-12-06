import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/common/background_gradient.dart';
import '../../../widgets/inputs/text_input.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../services/auth_service.dart';
import '../../admin/admin_dashboard_screen.dart';
import '../../main_navigation.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;
  _LoginRole _role = _LoginRole.user;

  @override
  void dispose() {
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
      // TODO: Integrate real authentication
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Set user ID based on role
      // User role: ID 1 (Sarah Johnson)
      // Admin role: ID 5 (Admin User)
      final int userId = _role == _LoginRole.admin ? 5 : 1;
      final String role = _role == _LoginRole.admin ? 'admin' : 'user';
      
      // Login using AuthService
      AuthService().login(userId: userId, role: role);
      
      if (!mounted) return;
      final Widget destination = _role == _LoginRole.admin
          ? const AdminDashboardScreen()
          : const MainNavigation(initialIndex: 0);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => destination),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

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
                    Text(
                      'Welcome back',
                      style: AppTextStyles.pageTitle.copyWith(
                        color: _role == _LoginRole.admin ? AppColors.primaryOrange : AppColors.primaryPurple,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Sign in to continue to LQitha', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    _RoleToggle(
                      role: _role,
                      onChanged: (r) => setState(() => _role = r),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                            validator: (v) => (v == null || v.length < 6) ? 'Enter your password' : null,
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            label: _role == _LoginRole.user ? 'Sign in as User' : 'Sign in as Admin',
                            onPressed: _isSubmitting ? null : _onSubmit,
                            backgroundColor: _role == _LoginRole.admin ? AppColors.primaryOrange : AppColors.primaryPurple,
                          ),
                          const SizedBox(height: 16),
                          _NoAccount(onTapSignup: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SignupScreen()),
                            );
                          }),
                        ],
                      ),
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

enum _LoginRole { user, admin }

class _RoleToggle extends StatelessWidget {
  final _LoginRole role;
  final ValueChanged<_LoginRole> onChanged;
  const _RoleToggle({required this.role, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final Color activeColor = role == _LoginRole.user ? AppColors.primaryPurple : AppColors.primaryOrange;
    final Color borderColor = activeColor;
    return Material(
      color: Colors.transparent,
      child: Container(
      height: 70.47,
      padding: const EdgeInsets.only(top: 9.26, left: 9.26, right: 9.26, bottom: 1.27),
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.80),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.27, color: borderColor),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(color: AppColors.shadowPurpleSubtle, blurRadius: 40, offset: Offset(0, 12)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: 'User',
              active: role == _LoginRole.user,
              activeColor: AppColors.primaryPurple,
              icon: Icons.person_outline,
              onTap: () => onChanged(_LoginRole.user),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _Segment(
              label: 'Admin',
              active: role == _LoginRole.admin,
              activeColor: AppColors.primaryOrange,
              icon: Icons.admin_panel_settings_outlined,
              onTap: () => onChanged(_LoginRole.admin),
            ),
          ),
        ],
      ),
    ));
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool active;
  final Color activeColor;
  final IconData icon;
  final VoidCallback onTap;
  const _Segment({required this.label, required this.active, required this.activeColor, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 51.94,
        decoration: ShapeDecoration(
          color: active ? activeColor : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadows: active
              ? const [
                  BoxShadow(color: AppColors.shadowBlack, blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4),
                  BoxShadow(color: AppColors.shadowBlack, blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : AppColors.textSecondary,
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _NoAccount extends StatelessWidget {
  final VoidCallback onTapSignup;
  const _NoAccount({required this.onTapSignup});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTapSignup,
          child: Text('Sign up', style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryPurple)),
        ),
      ],
    );
  }
}


