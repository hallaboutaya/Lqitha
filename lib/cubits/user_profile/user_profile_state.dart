import '../../../data/models/user.dart';


class UserProfileState {
  final bool loading;
  final User? user;
  final String? error;

  const UserProfileState({
    this.loading = false,
    this.user,
    this.error,
  });

  UserProfileState copyWith({
    bool? loading,
    User? user,
    String? error,
  }) {
    return UserProfileState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error,
    );
  }
}
