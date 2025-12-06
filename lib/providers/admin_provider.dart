// lib/providers/admin_provider.dart
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../data/repositories/found_repository.dart';
import '../data/repositories/lost_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/models/found_post.dart';
import '../data/models/lost_post.dart';
import '../services/service_locator.dart';

class AdminProvider with ChangeNotifier {
  List<Post> _allPosts = [];
  String _selectedTab = 'pending';
  String _searchQuery = '';
  bool _isLoading = false;

  final FoundRepository _foundRepository = getIt<FoundRepository>();
  final LostRepository _lostRepository = getIt<LostRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();

  AdminProvider() {
    loadAllPosts();
  }

  bool get isLoading => _isLoading;

  /// Load all posts from database (both found and lost)
  Future<void> loadAllPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final foundPosts = await _foundRepository.getAllPosts();
      final lostPosts = await _lostRepository.getAllPosts();

      // Convert FoundPost and LostPost to Post model (async conversion)
      final foundPostsConverted = await Future.wait(
        foundPosts.map((fp) => _foundPostToPost(fp)),
      );
      final lostPostsConverted = await Future.wait(
        lostPosts.map((lp) => _lostPostToPost(lp)),
      );

      _allPosts = [
        ...foundPostsConverted,
        ...lostPostsConverted,
      ];

      // Sort by creation date (newest first)
      _allPosts.sort((a, b) {
        // Simple sort - you might want to parse timestamps properly
        return b.timestamp.compareTo(a.timestamp);
      });
    } catch (e) {
      print('Error loading admin posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Convert FoundPost to Post model
  Future<Post> _foundPostToPost(FoundPost fp) async {
    String userName = 'User ${fp.userId ?? 'Unknown'}';
    if (fp.userId != null) {
      final username = await _userRepository.getUsernameById(fp.userId!);
      if (username != null) {
        userName = username;
      }
    }
    
    return Post(
      id: 'found_${fp.id}',
      userName: userName,
      userImage: 'https://i.pravatar.cc/150?img=${fp.userId ?? 1}',
      timestamp: fp.createdAt ?? 'Unknown',
      type: 'Found',
      description: fp.description ?? '',
      location: fp.location ?? '',
      categories: fp.category?.split(',').map((e) => e.trim()).toList() ?? [],
      imageUrl: fp.photo ?? 'https://placehold.co/400',
      status: fp.status,
    );
  }

  /// Convert LostPost to Post model
  Future<Post> _lostPostToPost(LostPost lp) async {
    String userName = 'User ${lp.userId ?? 'Unknown'}';
    if (lp.userId != null) {
      final username = await _userRepository.getUsernameById(lp.userId!);
      if (username != null) {
        userName = username;
      }
    }
    
    return Post(
      id: 'lost_${lp.id}',
      userName: userName,
      userImage: 'https://i.pravatar.cc/150?img=${lp.userId ?? 1}',
      timestamp: lp.createdAt ?? 'Unknown',
      type: 'Lost',
      description: lp.description ?? '',
      location: lp.location ?? '',
      categories: lp.category?.split(',').map((e) => e.trim()).toList() ?? [],
      imageUrl: lp.photo ?? 'https://placehold.co/400',
      status: lp.status,
    );
  }

  String get selectedTab => _selectedTab;
  String get searchQuery => _searchQuery;

  // Get filtered posts based on selected tab and search query
  List<Post> get filteredPosts {
    List<Post> posts = _allPosts.where((post) {
      return post.status == _selectedTab;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      posts = posts.where((post) {
        return post.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            post.userName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return posts;
  }

  // Get counts for each status
  int get totalPosts => _allPosts.length;
  int get pendingCount => _allPosts.where((p) => p.status == 'pending').length;
  int get approvedTodayCount =>
      _allPosts.where((p) => p.status == 'approved').length;
  int get activeUsers => 1523; // Static value as per design

  void setSelectedTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
    // Optionally reload posts when tab changes
    // loadAllPosts();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> approvePost(String postId) async {
    try {
      // Parse postId to get type and id (format: "found_1" or "lost_1")
      final parts = postId.split('_');
      if (parts.length != 2) return;
      
      final type = parts[0];
      final id = int.tryParse(parts[1]);
      if (id == null) return;

      // Update in database
      if (type == 'found') {
        await _foundRepository.updatePostStatus(id, 'approved');
      } else if (type == 'lost') {
        await _lostRepository.updatePostStatus(id, 'approved');
      }

      // Update local state
      final post = _allPosts.firstWhere((p) => p.id == postId);
      post.status = 'approved';
      notifyListeners();
    } catch (e) {
      print('Error approving post: $e');
    }
  }

  Future<void> rejectPost(String postId) async {
    try {
      // Parse postId to get type and id (format: "found_1" or "lost_1")
      final parts = postId.split('_');
      if (parts.length != 2) return;
      
      final type = parts[0];
      final id = int.tryParse(parts[1]);
      if (id == null) return;

      // Update in database
      if (type == 'found') {
        await _foundRepository.updatePostStatus(id, 'rejected');
      } else if (type == 'lost') {
        await _lostRepository.updatePostStatus(id, 'rejected');
      }

      // Update local state
      final post = _allPosts.firstWhere((p) => p.id == postId);
      post.status = 'rejected';
      notifyListeners();
    } catch (e) {
      print('Error rejecting post: $e');
    }
  }
}
