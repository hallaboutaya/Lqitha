import 'package:equatable/equatable.dart';
import '../../data/models/user_stats.dart';

abstract class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object?> get props => [];
}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

class UserManagementLoaded extends UserManagementState {
  final List<UserStats> users;
  final List<UserStats> filteredUsers;
  final Map<String, int> summary;

  const UserManagementLoaded({
    required this.users,
    this.filteredUsers = const [],
    this.summary = const {},
  });

  UserManagementLoaded copyWith({
    List<UserStats>? users,
    List<UserStats>? filteredUsers,
    Map<String, int>? summary,
  }) {
    return UserManagementLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [users, filteredUsers, summary];
}

class UserManagementError extends UserManagementState {
  final String message;

  const UserManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
