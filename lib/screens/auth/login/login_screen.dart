import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/common/background_gradient.dart';
import '../../../widgets/inputs/text_input.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/auth/auth_state.dart';
import '../../../services/service_locator.dart';
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
  _LoginRole _role = _LoginRole.user;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    print('🔵 Login: Submit button pressed');
    final form = _formKey.currentState;
    if (form == null) {
      print('❌ Login: Form key is null');
      return;
    }
    
    if (!form.validate()) {
      print('❌ Login: Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('✅ Login: Form validated, calling AuthCubit.login');
    print('📧 Email: ${_emailController.text.trim()}');
    
    // Trigger login via AuthCubit
    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    print('🔄 Login: AuthState changed: ${state.runtimeType}');
    
    if (state is AuthError) {
      print('❌ Login: Error state - ${state.message}');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } else if (state is AuthAuthenticated) {
      print('✅ Login: Authenticated - navigating to ${state.user.role == 'admin' ? 'admin' : 'main'}');
      // Navigate based on user role
      final Widget destination = state.user.role == 'admin'
          ? const AdminDashboardScreen()
          : const MainNavigation(initialIndex: 0);
      
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => destination),
        (route) => false,
      );
    } else if (state is AuthLoading) {
      print('⏳ Login: Loading state');
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
                            AppLocalizations.of(context)!.welcomeBack,
                            style: AppTextStyles.pageTitle.copyWith(
                              color: _role == _LoginRole.admin ? AppColors.primaryOrange : AppColors.primaryPurple,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(AppLocalizations.of(context)!.signInToContinue, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
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
                                Text(AppLocalizations.of(context)!.password, style: AppTextStyles.subtitle.copyWith(fontSize: 14, color: const Color(0xFF0A0A0A))),
                                const SizedBox(height: 8),
                                AuthTextField(
                                  controller: _passwordController,
                                  hintText: '••••••••',
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  validator: (v) => (v == null || v.length < 6) ? AppLocalizations.of(context)!.enterYourPassword : null,
                                ),
                                const SizedBox(height: 24),
                                PrimaryButton(
                                  label: isLoading 
                                    ? 'Loading...' 
                                    : (_role == _LoginRole.user ? AppLocalizations.of(context)!.signInAsUser : AppLocalizations.of(context)!.signInAsAdmin),
                                  onPressed: isLoading ? null : () {
                                    print('🔵 Button pressed!');
                                    _onSubmit(context);
                                  },
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
        },
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
              label: AppLocalizations.of(context)!.user,
              active: role == _LoginRole.user,
              activeColor: AppColors.primaryPurple,
              icon: Icons.person_outline,
              onTap: () => onChanged(_LoginRole.user),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _Segment(
              label: AppLocalizations.of(context)!.admin,
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
        Text(AppLocalizations.of(context)!.dontHaveAccount, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTapSignup,
          child: Text(AppLocalizations.of(context)!.signUp, style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryPurple)),
        ),
      ],
    );
  }
}


