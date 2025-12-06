import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/admin/admin_cubit.dart';
import '../../cubits/admin/admin_state.dart';
import '../../widgets/admin/stat_card.dart';
import '../../widgets/admin/tab_selector.dart';
import '../../widgets/admin/post_card.dart';
import '../../services/service_locator.dart';
import '../../services/auth_service.dart';
import '../auth/login/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AdminCubit>()..loadPendingPosts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              if (state is AdminLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AdminError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${state.message}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdminCubit>().loadPendingPosts();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is AdminLoaded) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildStatistics(state.statistics),
                        const SizedBox(height: 24),
                        _buildSearchBar(),
                        const SizedBox(height: 24),
                        TabSelector(
                          currentTab: state.currentTab,
                          onTabChanged: (tab) {
                            context.read<AdminCubit>().toggleTab(tab);
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildPostsList(state),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lqitha Admin',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Manage posts and platform activity',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Admin Panel'),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                // Logout and navigate to login screen
                AuthService().logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout, size: 18),
                  SizedBox(width: 4),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatistics(Map<String, int> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: 'Total Posts',
          value: stats['totalPosts']?.toString() ?? '0',
          icon: Icons.article,
          color: Colors.purple,
        ),
        StatCard(
          title: 'Pending Review',
          value: stats['pendingPosts']?.toString() ?? '0',
          icon: Icons.pending,
          color: Colors.orange,
        ),
        StatCard(
          title: 'Approved Today',
          value: stats['approvedToday']?.toString() ?? '0',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        StatCard(
          title: 'Active Users',
          value: stats['activeUsers']?.toString() ?? '0',
          icon: Icons.trending_up,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search posts...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPostsList(AdminLoaded state) {
    final foundPosts = state.foundPosts;
    final lostPosts = state.lostPosts;
    final totalCount = foundPosts.length + lostPosts.length;

    if (totalCount == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.inbox, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No posts to review',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        // Found posts come first, then lost posts
        if (index < foundPosts.length) {
          final post = foundPosts[index];
          final postId = post.id;
          if (postId == null) {
            return const SizedBox.shrink();
          }

          return PostCard(
            id: postId,
            type: 'found',
            photo: post.photo,
            username: 'User ${post.userId ?? "Unknown"}',
            userPhoto: null,
            createdAt: post.createdAt,
            postType: 'found',
            description: post.description,
            location: post.location,
            category: post.category,
            onApprove: () {
              context.read<AdminCubit>().approvePost(postId, 'found');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post approved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onReject: () {
              context.read<AdminCubit>().rejectPost(postId, 'found');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post rejected'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        } else {
          final lostIndex = index - foundPosts.length;
          final post = lostPosts[lostIndex];
          final postId = post.id;
          if (postId == null) {
            return const SizedBox.shrink();
          }

          return PostCard(
            id: postId,
            type: 'lost',
            photo: post.photo,
            username: 'User ${post.userId ?? "Unknown"}',
            userPhoto: null,
            createdAt: post.createdAt,
            postType: 'lost',
            description: post.description,
            location: post.location,
            category: post.category,
            onApprove: () {
              context.read<AdminCubit>().approvePost(postId, 'lost');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post approved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onReject: () {
              context.read<AdminCubit>().rejectPost(postId, 'lost');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post rejected'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        }
      },
    );
  }
}
