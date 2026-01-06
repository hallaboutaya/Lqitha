import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_profile_state.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/repositories/user_repository.dart';


class UserProfileCubit extends Cubit<UserProfileState> {
  final UserRepository repository;
  final String userId;

  UserProfileCubit({
    required this.repository,
    required this.userId,
  }) : super(const UserProfileState());

  Future<void> loadProfile() async {
    print('🔍 UserProfileCubit: Loading profile for userId=$userId');
    emit(state.copyWith(loading: true));
    try {
      final user = await repository.getUserProfile(userId);
      print('✅ UserProfileCubit: Loaded user: ${user?.username} (id=${user?.id})');
      emit(state.copyWith(loading: false, user: user));
    } catch (e) {
      print('❌ UserProfileCubit: Error loading profile: $e');
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> updateProfile({
    required String username,
    required String email,
    String? phoneNumber,
  }) async {
    emit(state.copyWith(loading: true));
    try {
      await repository.updateUserProfile(
        userId: userId,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        photo: state.user?.photo,
      );
      await loadProfile(); // reload updated profile
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> updatePhoto(String filePath) async {
    emit(state.copyWith(loading: true));
    try {
      // Copy image to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(filePath)}';
      final savedPath = join(appDir.path, fileName);
      await File(filePath).copy(savedPath);

      await repository.updateUserPhoto(userId, savedPath);
      await loadProfile();
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
