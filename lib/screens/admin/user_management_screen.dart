import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/admin/user_management_cubit.dart';
import '../../cubits/admin/user_management_state.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../data/models/user_stats.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.userInsights,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<UserManagementCubit, UserManagementState>(
        builder: (context, state) {
          if (state is UserManagementLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple));
          }

          if (state is UserManagementError) {
            return Center(child: Text('${AppLocalizations.of(context)!.error}: ${state.message}'));
          }

          if (state is UserManagementLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(context, state.summary),
                  const SizedBox(height: 24),
                  _buildSearchBar(context),
                  const SizedBox(height: 16),
                  _buildUserTable(context, state.filteredUsers),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, Map<String, int> summary) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: l10n.activeUsers,
            value: summary['totalUsers']?.toString() ?? '0',
            icon: Icons.people_outline,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: l10n.avgPoints,
            value: summary['averagePoints']?.toString() ?? '0',
            icon: Icons.stars_outlined,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: l10n.successRate,
            value: '${summary['globalSuccessRate']}%',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => context.read<UserManagementCubit>().searchUsers(value),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchUsersByName,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildUserTable(BuildContext context, List<UserStats> users) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              AppLocalizations.of(context)!.performanceRankings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
              columns: [
                DataColumn(label: Text(AppLocalizations.of(context)!.user)),
                DataColumn(label: Text(AppLocalizations.of(context)!.posts)),
                DataColumn(label: Text(AppLocalizations.of(context)!.denied)),
                DataColumn(label: Text(AppLocalizations.of(context)!.resolved)),
                DataColumn(label: Text(AppLocalizations.of(context)!.points)),
                DataColumn(label: Text(AppLocalizations.of(context)!.success)),
              ],
              rows: users.map((user) => DataRow(
                cells: [
                  DataCell(Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: user.photo != null ? NetworkImage(user.photo!) : null,
                        child: user.photo == null ? const Icon(Icons.person, size: 16) : null,
                      ),
                      const SizedBox(width: 8),
                      Text(user.username, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  )),
                  DataCell(Text(user.totalPosts.toString())),
                  DataCell(Text(user.rejectedPosts.toString(), style: const TextStyle(color: Colors.red))),
                  DataCell(Text(user.resolvedPosts.toString(), style: const TextStyle(color: Colors.green))),
                  DataCell(Text(user.points.toString(), style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold))),
                  DataCell(_buildSuccessChip(user.successRate)),
                ],
              )).toList(),
            ),
          ),
          if (users.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(child: Text(AppLocalizations.of(context)!.noUsersFoundMatchingSearch)),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSuccessChip(double rate) {
    Color color = Colors.red;
    if (rate >= 0.7) color = Colors.green;
    else if (rate >= 0.4) color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${(rate * 100).toStringAsFixed(0)}%',
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
