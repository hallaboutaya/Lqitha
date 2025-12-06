import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/admin_repository.dart';
import '../../data/models/lost_post.dart';
import '../../data/models/found_post.dart';
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

  Future<void> approvePost(int id, String type) async {
    try {
      await repository.approvePost(id, type);
      await loadPendingPosts();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> rejectPost(int id, String type) async {
    try {
      await repository.rejectPost(id, type);
      await loadPendingPosts();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
