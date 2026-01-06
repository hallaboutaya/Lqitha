import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../cubits/admin/admin_cubit.dart';
import '../../cubits/admin/admin_state.dart';
import '../../widgets/admin/stat_card.dart';
import '../../widgets/admin/tab_selector.dart';
import '../../widgets/admin/post_card.dart';
import '../../services/service_locator.dart';
import '../../services/auth_service.dart';
import '../../data/repositories/user_repository.dart';
import '../auth/login/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UserRepository _userRepository = getIt<UserRepository>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AdminCubit>()..loadPendingPosts(),
      child: Builder(
        builder: (scopedContext) {
          return BlocListener<AdminCubit, AdminState>(
            listener: (context, state) {
              if (state is AdminError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: SafeArea(
                child: BlocBuilder<AdminCubit, AdminState>(
                  builder: (context, state) {
                    if (state is AdminLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return _buildMainContent(context, state);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext scopedContext, AdminState state) {
    if (state is AdminError) {
      final l10n = AppLocalizations.of(scopedContext)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '${l10n.error}: ${state.message}',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                scopedContext.read<AdminCubit>().loadPendingPosts();
              },
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (state is AdminLoaded) {
      return RefreshIndicator(
        onRefresh: () => scopedContext.read<AdminCubit>().loadPendingPosts(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(scopedContext),
                const SizedBox(height: 24),
                _buildStatistics(scopedContext, state.statistics),
                const SizedBox(height: 24),
                _buildSearchBar(scopedContext),
                const SizedBox(height: 24),
                TabSelector(
                  currentTab: state.currentTab,
                  onTabChanged: (tab) {
                    scopedContext.read<AdminCubit>().toggleTab(tab);
                  },
                ),
                const SizedBox(height: 24),
                _buildPostsList(scopedContext, state),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildHeader(BuildContext scopedContext) {
    final l10n = AppLocalizations.of(scopedContext)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.lqithaAdmin,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.managePostsAndActivity,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                child: Text(l10n.adminPanel),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                // Logout and navigate to login screen
                AuthService().logout();
                Navigator.of(scopedContext).pushAndRemoveUntil(
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
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 18),
                  const SizedBox(width: 4),
                  Text(l10n.logout),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext scopedContext, Map<String, int> stats) {
    final l10n = AppLocalizations.of(scopedContext)!;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: l10n.totalPosts,
          value: stats['totalPosts']?.toString() ?? '0',
          icon: Icons.article,
          color: Colors.purple,
        ),
        StatCard(
          title: l10n.pendingReview,
          value: stats['pendingPosts']?.toString() ?? '0',
          icon: Icons.pending,
          color: Colors.orange,
        ),
        StatCard(
          title: l10n.approvedToday,
          value: stats['approvedToday']?.toString() ?? '0',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        StatCard(
          title: l10n.activeUsers,
          value: stats['activeUsers']?.toString() ?? '0',
          icon: Icons.trending_up,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext scopedContext) {
    final l10n = AppLocalizations.of(scopedContext)!;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.searchPosts,
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

  Widget _buildPostsList(BuildContext scopedContext, AdminLoaded state) {
    final foundPosts = state.foundPosts;
    final lostPosts = state.lostPosts;
    final totalCount = foundPosts.length + lostPosts.length;

    final l10n = AppLocalizations.of(scopedContext)!;
    if (totalCount == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Icon(Icons.inbox, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                l10n.noPostsToReview,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
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

          return FutureBuilder<String?>(
            future: post.userId != null 
                ? _userRepository.getUsernameById(post.userId!) 
                : Future.value(null),
            builder: (context, snapshot) {
              final username = snapshot.data ?? 'Unknown User';
              
              return PostCard(
                id: postId,
                type: 'found',
                photo: post.photo,
                username: username,
                userPhoto: null,
                createdAt: post.createdAt,
                postType: 'found',
                description: post.description,
                location: post.location,
                category: post.category,
                onApprove: () async {
                  final l10n = AppLocalizations.of(scopedContext)!;
                  await scopedContext.read<AdminCubit>().approvePost(postId, 'found');
                  if (mounted) {
                    ScaffoldMessenger.of(scopedContext).showSnackBar(
                      SnackBar(
                        content: Text(l10n.postApprovedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                onReject: () async {
                  final l10n = AppLocalizations.of(scopedContext)!;
                  await scopedContext.read<AdminCubit>().rejectPost(postId, 'found');
                  if (mounted) {
                    ScaffoldMessenger.of(scopedContext).showSnackBar(
                      SnackBar(
                        content: Text(l10n.postRejected),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
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

          return FutureBuilder<String?>(
            future: post.userId != null 
                ? _userRepository.getUsernameById(post.userId!) 
                : Future.value(null),
            builder: (context, snapshot) {
              final username = snapshot.data ?? 'Unknown User';
              
              return PostCard(
                id: postId,
                type: 'lost',
                photo: post.photo,
                username: username,
                userPhoto: null,
                createdAt: post.createdAt,
                postType: 'lost',
                description: post.description,
                location: post.location,
                category: post.category,
                onApprove: () async {
                  final l10n = AppLocalizations.of(scopedContext)!;
                  await scopedContext.read<AdminCubit>().approvePost(postId, 'lost');
                  if (mounted) {
                    ScaffoldMessenger.of(scopedContext).showSnackBar(
                      SnackBar(
                        content: Text(l10n.postApprovedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                onReject: () async {
                  final l10n = AppLocalizations.of(scopedContext)!;
                  await scopedContext.read<AdminCubit>().rejectPost(postId, 'lost');
                  if (mounted) {
                    ScaffoldMessenger.of(scopedContext).showSnackBar(
                      SnackBar(
                        content: Text(l10n.postRejected),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
