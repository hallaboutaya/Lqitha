import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../cubits/locale/locale_cubit.dart';
import '../../cubits/locale/locale_state.dart';
import '../../cubits/user_profile/user_profile_cubit.dart';
import '../profile/edit_profile_screen.dart';
import 'change_password_screen.dart';
import '../../services/auth_service.dart';
import '../auth/login/login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailAlerts = prefs.getBool('email_alerts') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('email_alerts', _emailAlerts);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundMid,
              AppColors.backgroundEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionTitle(l10n.profileAndSecurity),
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: l10n.editProfile,
                onTap: () {
                  final cubit = context.read<UserProfileCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: const EditProfileScreen(),
                      ),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                icon: Icons.lock_outline,
                title: l10n.changePassword,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(l10n.appSettings),
              _buildLanguageTile(context, l10n),
              _buildSettingsTile(
                icon: Icons.notifications_none,
                title: l10n.notifications,
                subtitle: l10n.manageAlerts,
                onTap: () => _showNotificationSettings(context, l10n),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(l10n.support),

              _buildSettingsTile(
                icon: Icons.info_outline,
                title: l10n.aboutLqitha,
                onTap: () => _showAboutDialog(context, l10n),
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.logout,
                title: l10n.logout,
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () => _handleLogout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showNotificationSettings(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.notifications),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(l10n.pushNotifications),
                value: _pushNotifications,
                onChanged: (val) {
                  setDialogState(() => _pushNotifications = val);
                  setState(() {});
                },
                activeColor: AppColors.primaryOrange,
              ),
              SwitchListTile(
                title: Text(l10n.emailAlerts),
                value: _emailAlerts,
                onChanged: (val) {
                  setDialogState(() => _emailAlerts = val);
                  setState(() {});
                },
                activeColor: AppColors.primaryOrange,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                _saveSettings();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.settingsSaved),
                    backgroundColor: AppColors.primaryPurple,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.aboutLqitha),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.stars, color: AppColors.primaryPurple, size: 40),
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.lqithaDescription, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 20),
            _buildAboutInfo(l10n.appVersion, "1.0.0"),
            _buildAboutInfo(l10n.developers, "Lqitha Team"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primaryPurple.withOpacity(0.8),
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primaryPurple).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primaryPurple, size: 22),
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: Icon(Icons.chevron_right, color: textColor?.withOpacity(0.5) ?? Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        String currentLang = _getLanguageName(state.locale.languageCode);
        return _buildSettingsTile(
          icon: Icons.language,
          title: l10n.language,
          subtitle: currentLang,
          onTap: () => _showLanguageDialog(context, state.locale.languageCode, l10n),
        );
      },
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'fr': return 'Français';
      case 'ar': return 'العربية';
      default: return 'English';
    }
  }

  void _showLanguageDialog(BuildContext context, String currentCode, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.chooseLanguage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLangOption(context, 'English', 'en', currentCode),
            _buildLangOption(context, 'Français', 'fr', currentCode),
            _buildLangOption(context, 'العربية', 'ar', currentCode),
          ],
        ),
      ),
    );
  }

  Widget _buildLangOption(BuildContext context, String name, String code, String currentCode) {
    return ListTile(
      title: Text(name),
      trailing: code == currentCode 
          ? const Icon(Icons.check_circle, color: AppColors.primaryPurple) 
          : null,
      onTap: () {
        context.read<LocaleCubit>().changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}
