import 'package:flutter/material.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../core/utils/time_formatter.dart';
import '../../models/profile_post_model.dart';
import '../../data/models/found_post.dart';
import '../../data/models/lost_post.dart';
import '../../data/repositories/found_repository.dart';
import '../../data/repositories/lost_repository.dart';
import '../../services/service_locator.dart';
import 'post_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyPostsTabs extends StatefulWidget {
  final dynamic userId; // Can be int (SQLite) or String (UUID from Supabase)
  
  const MyPostsTabs({super.key, required this.userId});

  @override
  State<MyPostsTabs> createState() => _MyPostsTabsState();
}

class _MyPostsTabsState extends State<MyPostsTabs> {
  int _selectedIndex = 0;
  List<ProfilePost> validatedPosts = [];
  List<ProfilePost> onHoldPosts = [];
  List<ProfilePost> rejectedPosts = [];
  bool _isLoading = true;
  
  final FoundRepository _foundRepository = getIt<FoundRepository>();
  final LostRepository _lostRepository = getIt<LostRepository>();

  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  Future<void> _loadUserPosts() async {
    setState(() => _isLoading = true);
    
    try {
      // Fetch found posts for THIS USER ONLY using repository
      final foundPosts = await _foundRepository.getPostsByUserId(widget.userId);
      
      // Fetch lost posts for THIS USER ONLY using repository
      final lostPosts = await _lostRepository.getPostsByUserId(widget.userId);
      
      // Convert to ProfilePost models
      final List<ProfilePost> allPosts = [];
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        for (final foundPost in foundPosts) {
          allPosts.add(_convertToProfilePost(foundPost, isFound: true, l10n: l10n));
        }
        
        for (final lostPost in lostPosts) {
          allPosts.add(_convertToProfilePost(lostPost, isFound: false, l10n: l10n));
        }
      }
      
      // Group by status
      setState(() {
        validatedPosts = allPosts.where((p) => p.status == 'validated').toList();
        onHoldPosts = allPosts.where((p) => p.status == 'on_hold').toList();
        rejectedPosts = allPosts.where((p) => p.status == 'rejected').toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user posts: $e');
      setState(() => _isLoading = false);
    }
  }

  ProfilePost _convertToProfilePost(dynamic post, {required bool isFound, required AppLocalizations l10n}) {
    final String postType = isFound ? l10n.found : l10n.lost;
    final String description = post.description ?? 'No description';
    final String category = post.category ?? 'Item';
    
    // Map database status to UI status
    String uiStatus;
    String? note;
    
    switch (post.status) {
      case 'approved':
        uiStatus = 'validated';
        break;
      case 'pending':
        uiStatus = 'on_hold';
        note = l10n.waitingForAdminApproval;
        break;
      case 'rejected':
        uiStatus = 'rejected';
        note = l10n.postWasRejectedByAdmin;
        break;
      default:
        uiStatus = 'on_hold';
    }
    
    // Format date
    String dateStr = 'Unknown';
    if (post.createdAt != null) {
      dateStr = TimeFormatter.formatTimeAgoFromString(post.createdAt, l10n);
      if (dateStr.isEmpty) dateStr = post.createdAt!;
    }
    
    return ProfilePost(
      title: '$postType: $category - ${description.length > 40 ? '${description.substring(0, 40)}...' : description}',
      location: post.location ?? 'Unknown location',
      imageUrl: post.photo ?? 'https://via.placeholder.com/400',
      status: uiStatus,
      date: dateStr,
      note: note,
    );
  }

  List<ProfilePost> get _currentPosts {
    if (_selectedIndex == 0) return validatedPosts;
    if (_selectedIndex == 1) return onHoldPosts;
    return rejectedPosts;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.myPosts,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _tabButton(l10n.validated, 0),
            _tabButton(l10n.onHold, 1),
            _tabButton(l10n.rejected, 2),
          ],
        ),
        const SizedBox(height: 12),
        _isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : _currentPosts.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        l10n.noPostsInCategory,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )
                : Column(
                    children: _currentPosts
                        .map((post) => PostCard(post: post))
                        .toList(),
                  ),
      ],
    );
  }

  Widget _tabButton(String text, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepPurple.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.deepPurple : Colors.black54,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
