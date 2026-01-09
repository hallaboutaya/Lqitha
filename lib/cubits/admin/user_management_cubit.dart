import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/admin_repository.dart';
import '../../data/models/user_stats.dart';
import 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final AdminRepository _repository;

  UserManagementCubit(this._repository) : super(UserManagementInitial());

  Future<void> loadUsers() async {
    try {
      emit(UserManagementLoading());
      
      final users = await _repository.getAllUserStats();
      
      // Calculate summary
      int totalUsers = users.length;
      int totalPoints = users.fold(0, (sum, u) => sum + u.points);
      int totalPosts = users.fold(0, (sum, u) => sum + u.totalPosts);
      int totalResolved = users.fold(0, (sum, u) => sum + u.resolvedPosts);
      
      final summary = {
        'totalUsers': totalUsers,
        'averagePoints': totalUsers > 0 ? (totalPoints / totalUsers).round() : 0,
        'totalPosts': totalPosts,
        'globalSuccessRate': totalPosts > 0 ? ((totalResolved / totalPosts) * 100).round() : 0,
      };

      emit(UserManagementLoaded(
        users: users,
        filteredUsers: users,
        summary: summary,
      ));
    } catch (e) {
      emit(UserManagementError(e.toString()));
    }
  }

  void searchUsers(String query) {
    if (state is UserManagementLoaded) {
      final current = state as UserManagementLoaded;
      if (query.isEmpty) {
        emit(current.copyWith(filteredUsers: current.users));
        return;
      }

      final filtered = current.users.where((user) {
        return user.username.toLowerCase().contains(query.toLowerCase());
      }).toList();

      emit(current.copyWith(filteredUsers: filtered));
    }
  }

  void sortUsers(String criteria) {
    if (state is UserManagementLoaded) {
      final current = state as UserManagementLoaded;
      final usersToSort = List<UserStats>.from(current.filteredUsers);

      switch (criteria) {
        case 'points':
          usersToSort.sort((a, b) => b.points.compareTo(a.points));
          break;
        case 'posts':
          usersToSort.sort((a, b) => b.totalPosts.compareTo(a.totalPosts));
          break;
        case 'name':
          usersToSort.sort((a, b) => a.username.compareTo(b.username));
          break;
      }

      emit(current.copyWith(filteredUsers: usersToSort));
    }
  }
}
