import 'package:flutter/material.dart';
import '../../models/profile_post_model.dart';
import '../../data/models/found_post.dart';
import '../../data/models/lost_post.dart';
import '../../data/databases/db_helper.dart';
import 'post_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyPostsTabs extends StatefulWidget {
  final int userId;
  
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

  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  Future<void> _loadUserPosts() async {
    setState(() => _isLoading = true);
    
    try {
      final db = await DBHelper.getDatabase();
      
      // Fetch found posts for THIS USER ONLY
      final foundMaps = await db.query(
        'found_posts',
        where: 'user_id = ?',
        whereArgs: [widget.userId],
      );
      
      // Fetch lost posts for THIS USER ONLY
      final lostMaps = await db.query(
        'lost_posts',
        where: 'user_id = ?',
        whereArgs: [widget.userId],
      );
      
      // Convert to ProfilePost models
      final List<ProfilePost> allPosts = [];
      
      for (final map in foundMaps) {
        final foundPost = FoundPost.fromMap(map);
        allPosts.add(_convertToProfilePost(foundPost, isFound: true));
      }
      
      for (final map in lostMaps) {
        final lostPost = LostPost.fromMap(map);
        allPosts.add(_convertToProfilePost(lostPost, isFound: false));
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

  ProfilePost _convertToProfilePost(dynamic post, {required bool isFound}) {
    final String postType = isFound ? 'Found' : 'Lost';
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
        note = 'Waiting for admin approval';
        break;
      case 'rejected':
        uiStatus = 'rejected';
        note = 'Post was rejected by admin';
        break;
      default:
        uiStatus = 'on_hold';
    }
    
    // Format date
    String dateStr = 'Unknown';
    if (post.createdAt != null) {
      try {
        final createdDate = DateTime.parse(post.createdAt!);
        dateStr = timeago.format(createdDate);
      } catch (e) {
        dateStr = post.createdAt!;
      }
    }
    
    return ProfilePost(
      title: '$postType: $category - ${description.length > 40 ? description.substring(0, 40) + '...' : description}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Posts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _tabButton('Validated', 0),
            _tabButton('On Hold', 1),
            _tabButton('Rejected', 2),
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
                        'No posts in this category',
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
