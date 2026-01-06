/// Lost Items page displaying list of items that have been lost.
/// 
/// Features:
/// - Page header with orange accent bar
/// - Search bar for filtering items by description or location
/// - List of LostItemCard widgets showing lost items
/// - Floating action button (+) to report a new lost item
/// 
/// This is the second tab (index 1) in the bottom navigation.
/// Items are filtered in real-time as the user types in the search bar.
library;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../widgets/inputs/search_bar.dart';
import '../../widgets/cards/lost_item_card.dart';
import '../../widgets/common/background_gradient.dart';
import '../../widgets/popups/popup_lost_item.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../cubits/lost/lost_cubit.dart';
import '../../cubits/lost/lost_state.dart';
import '../../services/service_locator.dart';
import '../../data/repositories/user_repository.dart';

class LostsPage extends StatefulWidget {
  /// Current bottom navigation index (passed from MainNavigation)
  final int currentIndex;
  
  /// Callback to navigate to other pages (passed from MainNavigation)
  final Function(int) onNavTap;

  const LostsPage({
    super.key,
    this.currentIndex = 1,
    required this.onNavTap,
  });

  @override
  State<LostsPage> createState() => _LostsPageState();
}

class _LostsPageState extends State<LostsPage> {
  late final LostCubit _lostCubit;
  final UserRepository _userRepository = getIt<UserRepository>();

  @override
  void initState() {
    super.initState();
    // Get cubit from service locator
    _lostCubit = getIt<LostCubit>();
    // Load approved posts from database
    _lostCubit.loadApprovedPosts();
  }

  @override
  void dispose() {
    _lostCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: _lostCubit,
      child: Scaffold(
        body: BackgroundGradient(
          child: SafeArea(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.lostItems,
                              style: AppTextStyles.pageTitle.copyWith(
                                color: AppColors.primaryOrange,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.helpFindLostBelongings,
                              style: AppTextStyles.subtitle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomSearchBar(
                    hintText: AppLocalizations.of(context)!.searchLostItems,
                    onChanged: (value) {
                      _lostCubit.searchPosts(value);
                    },
                    onFilterTap: () {
                      // Handle filter tap
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // List of Lost Items - Using BlocBuilder to listen to state
                Expanded(
                  child: BlocBuilder<LostCubit, LostState>(
                    builder: (context, state) {
                      if (state is LostLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (state is LostError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.message),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _lostCubit.loadApprovedPosts(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      if (state is LostLoaded) {
                        final posts = state.posts;
                        
                        if (posts.isEmpty) {
                          return Center(
                            child: Text(
                              state.message ?? 'No lost items yet',
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                          );
                        }
                        
                        return RefreshIndicator(
                          onRefresh: () => _lostCubit.refresh(),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              // Parse category as tags (comma-separated)
                              final tags = post.category?.split(',').map((e) => e.trim()).toList() ?? [];
                              
                              return FutureBuilder<String?>(
                                future: post.userId != null 
                                    ? _userRepository.getUsernameById(post.userId!).catchError((e) {
                                        print('Error getting username: $e');
                                        return null;
                                      })
                                    : Future.value(null),
                                builder: (context, snapshot) {
                                  final userName = snapshot.data ?? 'User ${post.userId ?? 'Unknown'}';
                                  
                                  return LostItemCard(
                                    key: ValueKey('lost_${post.id}_${post.userId}'),
                                    postId: post.id,
                                    postOwnerId: post.userId,
                                    userName: userName,
                                    timeAgo: _formatTimeAgo(post.createdAt),
                                    description: post.description ?? '',
                                    location: post.location ?? '',
                                    tags: tags,
                                    imageUrl: post.photo ?? 'https://placehold.co/294x256',
                                    photoUrl: post.photo,
                                    borderColor: AppColors.primaryOrange,
                                    hasReward: false, // TODO: Add reward field to model
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                      
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      // Floating Action Button for Adding Lost Item
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: ShapeDecoration(
          color: AppColors.locationBadgeBgOrange,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.27,
              color: Color(0x4CFF6B35),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19FF6B35),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 12,
                height: 12,
                decoration: ShapeDecoration(
                  color: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: AppColors.shadowBlack,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: AppColors.shadowBlack,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                      spreadRadius: -1,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: IconButton(
                icon: const Icon(Icons.add, color: AppColors.primaryOrange),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => BlocProvider.value(
                      value: _lostCubit,
                      child: const LostItemPopup(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
  
  /// Format timestamp to relative time string
  String _formatTimeAgo(String? createdAt) {
    if (createdAt == null) return 'Unknown time';
    
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else {
        return '${difference.inDays ~/ 7} week${(difference.inDays ~/ 7) > 1 ? 's' : ''} ago';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}

