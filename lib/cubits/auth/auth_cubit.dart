import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../services/service_locator.dart';
import '../../core/logging/app_logger.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/errors/app_exceptions.dart' as errors;
import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;
  final AuthService _authService;

  AuthCubit({
    required UserRepository userRepository,
    required AuthService authService,
  })  : _userRepository = userRepository,
        _authService = authService,
        super(const AuthInitial());


  Future<void> checkAuthStatus() async {
    try {
      await _authService.loadSession();
      
      if (_authService.isLoggedIn) {
        final user = await _userRepository.getUserById(_authService.currentUserId!);
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          // User ID in session but user doesn't exist in DB
          await _authService.clearSession();
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }


  Future<void> login({
    required String email,
    required String password,
  }) async {
    AppLogger.d('🔐 AuthCubit: Login called with email=$email');
    emit(const AuthLoading());

    try {
      AppLogger.d('🔍 AuthCubit: Validating credentials...');
      final user = await _userRepository.validateCredentials(email, password);

      if (user == null) {
        AppLogger.w('❌ AuthCubit: Invalid credentials');
        emit(AuthError(
          message: errors.ErrorMessageHelper.getUserFriendlyMessage(
            AuthenticationException.invalidCredentials(),
          ),
        ));
        return;
      }

      AppLogger.i('✅ AuthCubit: Credentials valid, saving session...');
      // Save session (user.id can be int or String UUID)
      await _authService.login(userId: user.id, role: user.role);

      // Register FCM token
      try {
        await getIt<NotificationService>().registerToken();
      } catch (e) {
        AppLogger.e('⚠️ Failed to register FCM token during login', e);
      }

      AppLogger.i('✅ AuthCubit: Login successful, emitting AuthAuthenticated');
      emit(AuthAuthenticated(user: user));
    } catch (e, stackTrace) {
      AppLogger.e('❌ AuthCubit: Login error', e, stackTrace);
      final errorMessage = e is AppException
          ? errors.ErrorMessageHelper.getUserFriendlyMessage(e)
          : errors.ErrorMessageHelper.fromError(e);
      emit(AuthError(message: errorMessage));
    }
  }

  /// Sign up new user
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    AppLogger.d('🔐 AuthCubit: Signup called');
    AppLogger.d('👤 Username: $username, Email: $email');
    emit(const AuthLoading());

    try {
      // Check if email already exists
      AppLogger.d('🔍 AuthCubit: Checking if email exists...');
      final emailExists = await _userRepository.emailExists(email);
      if (emailExists) {
        AppLogger.w('❌ AuthCubit: Email already registered');
        emit(const AuthError(message: 'Email already registered'));
        return;
      }

      // Create new user
      AppLogger.i('✅ AuthCubit: Creating new user...');
      final newUser = User(
        username: username,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        role: 'user',
        points: 0,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      final userId = await _userRepository.createUser(newUser);
      AppLogger.i('✅ AuthCubit: User created with ID: $userId');

      // Get the created user
      final user = await _userRepository.getUserById(userId);
      if (user == null) {
        AppLogger.e('❌ AuthCubit: Failed to retrieve created user');
        emit(const AuthError(message: 'Failed to create account'));
        return;
      }

      // Save session (user.id can be int or String UUID)
      AppLogger.i('✅ AuthCubit: Saving session...');
      await _authService.login(userId: user.id, role: user.role);

      // Register FCM token
      try {
        await getIt<NotificationService>().registerToken();
      } catch (e) {
        AppLogger.e('⚠️ Failed to register FCM token during signup', e);
      }

      AppLogger.i('✅ AuthCubit: Signup successful, emitting AuthAuthenticated');
      emit(AuthAuthenticated(user: user));
    } catch (e, stackTrace) {
      AppLogger.e('❌ AuthCubit: Signup error', e, stackTrace);
      final errorMessage = e is AppException
          ? errors.ErrorMessageHelper.getUserFriendlyMessage(e)
          : errors.ErrorMessageHelper.fromError(e);
      emit(AuthError(message: errorMessage));
    }
  }

  /// Logout current user
  Future<void> logout() async {
    await _authService.logout();
    emit(const AuthUnauthenticated());
  }
}
