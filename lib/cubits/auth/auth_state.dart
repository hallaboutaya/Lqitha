import 'package:equatable/equatable.dart';
import '../../data/models/user.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during authentication operations
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated and logged in
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error occurred during authentication
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
