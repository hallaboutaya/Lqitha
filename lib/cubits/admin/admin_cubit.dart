import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/admin_repository.dart';
import '../../data/repositories/found_repository.dart';
import '../../data/repositories/lost_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/models/lost_post.dart';
import '../../data/models/found_post.dart';
import '../../data/models/notification.dart';
import '../../services/service_locator.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository repository;

  AdminCubit(this.repository) : super(AdminInitial());

  Future<void> loadPendingPosts() async {
    try {
      emit(AdminLoading());

      final lostPosts = await repository.getPendingLostPosts();
      final foundPosts = await repository.getPendingFoundPosts();
      final statistics = await repository.getStatistics();

      emit(
        AdminLoaded(
          lostPosts: lostPosts,
          foundPosts: foundPosts,
          currentTab: 'pending',
          statistics: statistics,
        ),
      );
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> toggleTab(String tab) async {
    if (state is AdminLoaded) {
      final current = state as AdminLoaded;
      emit(AdminLoading());

      try {
        List<LostPost> lostPosts = [];
        List<FoundPost> foundPosts = [];

        if (tab == 'pending') {
          lostPosts = await repository.getPendingLostPosts();
          foundPosts = await repository.getPendingFoundPosts();
        } else if (tab == 'approved') {
          lostPosts = await repository.getApprovedLostPosts();
          foundPosts = await repository.getApprovedFoundPosts();
        } else if (tab == 'rejected') {
          lostPosts = await repository.getRejectedLostPosts();
          foundPosts = await repository.getRejectedFoundPosts();
        } else if (tab == 'resolved') {
          lostPosts = await repository.getDoneLostPosts();
          foundPosts = await repository.getDoneFoundPosts();
        }

        emit(
          current.copyWith(
            currentTab: tab,
            lostPosts: lostPosts,
            foundPosts: foundPosts,
          ),
        );
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    }
  }

  Future<void> approvePost(dynamic id, String type) async {
    try {
      dynamic postUserId;
      try {
        if (type == 'found') {
          final foundRepository = getIt<FoundRepository>();
          final post = await foundRepository.getPostById(id);
          postUserId = post?.userId;
        } else if (type == 'lost') {
          final lostRepository = getIt<LostRepository>();
          final post = await lostRepository.getPostById(id);
          postUserId = post?.userId;
        }
      } catch (e) {
        print('⚠️ AdminCubit: Could not fetch post owner for notification: $e');
      }
      
      // Approve the post
      await repository.approvePost(id, type);
      
      // Create notification for the post owner if userId exists
      if (postUserId != null) {
        try {
          final notificationRepository = getIt<NotificationRepository>();
          final postType = type == 'found' ? 'found item' : 'lost item';
          final notification = NotificationModel(
            title: 'Post Approved',
            message: 'Admin approved your $postType post and it is now visible to users.',
            relatedPostId: id,
            type: 'post_approved',
            isRead: false,
            createdAt: DateTime.now().toIso8601String(),
            userId: postUserId,
          );
          await notificationRepository.insertNotification(notification);
          print('🔔 Created approval notification for user $postUserId');
        } catch (e) {
          print('❌ AdminCubit: Error sending approval notification: $e');
          // Don't rethrow, approval itself succeeded
        }
      }
      
      await loadPendingPosts();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> rejectPost(dynamic id, String type) async {
    try {
      dynamic postUserId;
      try {
        if (type == 'found') {
          final foundRepository = getIt<FoundRepository>();
          final post = await foundRepository.getPostById(id);
          postUserId = post?.userId;
        } else if (type == 'lost') {
          final lostRepository = getIt<LostRepository>();
          final post = await lostRepository.getPostById(id);
          postUserId = post?.userId;
        }
      } catch (e) {
        print('⚠️ AdminCubit: Could not fetch post owner for notification: $e');
      }
      
      // Reject the post
      await repository.rejectPost(id, type);
      
      // Create notification for the post owner if userId exists
      if (postUserId != null) {
        try {
          final notificationRepository = getIt<NotificationRepository>();
          final postType = type == 'found' ? 'found item' : 'lost item';
          final notification = NotificationModel(
            title: 'Post Rejected',
            message: 'Admin rejected your $postType post.',
            relatedPostId: id,
            type: 'post_rejected',
            isRead: false,
            createdAt: DateTime.now().toIso8601String(),
            userId: postUserId,
          );
          await notificationRepository.insertNotification(notification);
          print('🔔 Created rejection notification for user $postUserId');
        } catch (e) {
          print('❌ AdminCubit: Error sending rejection notification: $e');
          // Don't rethrow, rejection itself succeeded
        }
      }
      
      await loadPendingPosts();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
