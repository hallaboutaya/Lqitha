/// Found Items page displaying list of items that have been found.
/// 
/// Features:
/// - Page header with purple accent bar
/// - Search bar for filtering items by description or location
/// - List of FoundItemCard widgets showing found items
/// - Floating action button (+) to report a new found item
/// 
/// This is the first tab (index 0) in the bottom navigation.
/// Items are filtered in real-time as the user types in the search bar.
library;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../widgets/inputs/search_bar.dart';
import '../../widgets/cards/found_item_card.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/background_gradient.dart';
import '../../widgets/popups/popup_found_item.dart';
import '../../theme/app_colors.dart';
import '../../cubits/found/found_cubit.dart';
import '../../cubits/found/found_state.dart';
import '../../data/models/found_post.dart';
import '../../services/service_locator.dart';
import '../../data/repositories/user_repository.dart';

class FoundsPage extends StatefulWidget {
  /// Current bottom navigation index (passed from MainNavigation)
  final int currentIndex;
  
  /// Callback to navigate to other pages (passed from MainNavigation)
  final Function(int) onNavTap;

  const FoundsPage({
    super.key,
    this.currentIndex = 0,
    required this.onNavTap,
  });

  @override
  State<FoundsPage> createState() => _FoundsPageState();
}

class _FoundsPageState extends State<FoundsPage> {
  late final FoundCubit _foundCubit;
  final UserRepository _userRepository = getIt<UserRepository>();

  @override
  void initState() {
    super.initState();
    // Get cubit from service locator
    _foundCubit = getIt<FoundCubit>();
    // Load approved posts from database
    _foundCubit.loadApprovedPosts();
  }

  @override
  void dispose() {
    _foundCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: _foundCubit,
      child: Scaffold(
        body: BackgroundGradient(
          child: SafeArea(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: PageHeader(
                    title: AppLocalizations.of(context)!.foundItems,
                    subtitle: AppLocalizations.of(context)!.helpReuniteItems,
                  ),
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomSearchBar(
                    hintText: AppLocalizations.of(context)!.searchItemsTagsLocations,
                    onChanged: (value) {
                      _foundCubit.searchPosts(value);
                    },
                    onFilterTap: () {
                      // Handle filter tap
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // List of Found Items - Using BlocBuilder to listen to state
                Expanded(
                  child: BlocBuilder<FoundCubit, FoundState>(
                    builder: (context, state) {
                      if (state is FoundLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (state is FoundError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.message),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _foundCubit.loadApprovedPosts(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      if (state is FoundLoaded) {
                        final posts = state.posts;
                        
                        if (posts.isEmpty) {
                          return Center(
                            child: Text(
                              state.message ?? 'No found items yet',
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                          );
                        }
                        
                        return RefreshIndicator(
                          onRefresh: () => _foundCubit.refresh(),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              // Parse category as tags (comma-separated)
                              final tags = post.category?.split(',').map((e) => e.trim()).toList() ?? [];
                              
                              return FutureBuilder<String?>(
                                future: post.userId != null 
                                    ? _userRepository.getUsernameById(post.userId!) 
                                    : Future.value(null),
                                builder: (context, snapshot) {
                                  final userName = snapshot.data ?? 'User ${post.userId ?? 'Unknown'}';
                                  
                                  return FoundItemCard(
                                    userName: userName,
                                    timeAgo: _formatTimeAgo(post.createdAt),
                                    description: post.description ?? '',
                                    location: post.location ?? '',
                                    tags: tags,
                                    imageUrl: post.photo ?? 'https://placehold.co/301x256',
                                    borderColor: AppColors.primaryPurple,
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
      // Floating Action Button for Adding Found Item
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: ShapeDecoration(
          color: AppColors.locationBadgeBg,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.17,
              color: AppColors.borderPurpleSolid,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: AppColors.shadowPurpleLight,
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 46.83,
              top: 5.17,
              child: Container(
                width: 12,
                height: 12,
                decoration: ShapeDecoration(
                  color: AppColors.primaryOrange,
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
                icon: const Icon(Icons.add, color: AppColors.primaryPurple),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => BlocProvider.value(
                      value: _foundCubit,
                      child: const FoundItemPopup(),
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
