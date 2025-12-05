import 'package:flutter/material.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/points_card.dart';
import '../../widgets/profile/stats_card.dart';
import '../../widgets/profile/recent_activity.dart';
import '../../widgets/profile/my_posts_tabs.dart';

class MainProfilePage extends StatelessWidget {
  const MainProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ProfileHeader(),
              PointsCard(),
              StatsCard(),
              SizedBox(height: 20),
              RecentActivity(),
              SizedBox(height: 20),
              MyPostsTabs(),
              SizedBox(height: 20),
              _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
