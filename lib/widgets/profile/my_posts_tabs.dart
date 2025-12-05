import 'package:flutter/material.dart';
import '../../models/profile_post_model.dart';
import 'post_card.dart';

class MyPostsTabs extends StatefulWidget {
  const MyPostsTabs({super.key});

  @override
  State<MyPostsTabs> createState() => _MyPostsTabsState();
}

class _MyPostsTabsState extends State<MyPostsTabs> {
  int _selectedIndex = 0;

  final List<ProfilePost> validatedPosts = [
    const ProfilePost(
      title: 'Found a black leather wallet near',
      location: 'Agdal Metro',
      imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=400',
      status: 'validated',
      date: '2h ago',
    ),
  ];

  final List<ProfilePost> onHoldPosts = [
    const ProfilePost(
      title: 'Lost my silver iPhone with a clear case',
      location: 'Bab El Ouzar Mall',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
      status: 'on_hold',
      date: '1d ago',
      note: 'Waiting for admin approval',
    ),
  ];

  final List<ProfilePost> rejectedPosts = [
    const ProfilePost(
      title: 'Blue backpack found at the coffee shop',
      location: 'Café Centrale',
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=400',
      status: 'rejected',
      date: '3d ago',
      note: 'Image quality too low. Please upload clearer photo.',
    ),
  ];

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
        Column(
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
