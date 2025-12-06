import '../../data/models/lost_post.dart';
import '../../data/models/found_post.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<LostPost> lostPosts;
  final List<FoundPost> foundPosts;
  final String currentTab;
  final Map<String, int> statistics;

  AdminLoaded({
    required this.lostPosts,
    required this.foundPosts,
    required this.currentTab,
    required this.statistics,
  });

  AdminLoaded copyWith({
    List<LostPost>? lostPosts,
    List<FoundPost>? foundPosts,
    String? currentTab,
    Map<String, int>? statistics,
  }) {
    return AdminLoaded(
      lostPosts: lostPosts ?? this.lostPosts,
      foundPosts: foundPosts ?? this.foundPosts,
      currentTab: currentTab ?? this.currentTab,
      statistics: statistics ?? this.statistics,
    );
  }
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}
