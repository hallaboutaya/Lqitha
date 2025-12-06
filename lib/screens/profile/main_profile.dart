import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/points_card.dart';
import '../../widgets/profile/stats_card.dart';
import '../../widgets/profile/recent_activity.dart';
import '../../widgets/profile/my_posts_tabs.dart';
import '../../cubits/user_profile/user_profile_cubit.dart';
import '../../services/service_locator.dart';
import '../../services/auth_service.dart';
import '../../screens/auth/login/login_screen.dart';

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({super.key});

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  late final UserProfileCubit _userProfileCubit;
  late final int _userId;

  @override
  void initState() {
    super.initState();
    // Get current user ID from AuthService
    // If not logged in, default to user ID 1 (Sarah Johnson)
    _userId = AuthService().currentUserId ?? 1;
    
    print('👤 MainProfilePage: Initializing with userId=$_userId');
    print('🔐 AuthService: currentUserId=${AuthService().currentUserId}, role=${AuthService().currentUserRole}');
    
    // Create cubit with the logged-in user ID
    _userProfileCubit = getIt<UserProfileCubit>(param1: _userId.toString());
    _userProfileCubit.loadProfile();
  }

  @override
  void dispose() {
    _userProfileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userProfileCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F8FF),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ProfileHeader(),
                const PointsCard(),
                StatsCard(userId: _userId),
                const SizedBox(height: 20),
                const RecentActivity(),
                const SizedBox(height: 20),
                MyPostsTabs(userId: _userId),
                const SizedBox(height: 20),
                _LogoutButton(onLogout: _handleLogout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    // Logout and navigate to login screen
    AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;
  
  const _LogoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onLogout,
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
