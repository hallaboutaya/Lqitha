// lib/providers/admin_provider.dart
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/dummy_service.dart';

class AdminProvider with ChangeNotifier {
  List<Post> _allPosts = [];
  String _selectedTab = 'pending';
  String _searchQuery = '';

  AdminProvider() {
    _allPosts = DummyService.getDummyPosts();
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
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void approvePost(String postId) {
    final post = _allPosts.firstWhere((p) => p.id == postId);
    post.status = 'approved';
    notifyListeners();
  }

  void rejectPost(String postId) {
    final post = _allPosts.firstWhere((p) => p.id == postId);
    post.status = 'rejected';
    notifyListeners();
  }
}
