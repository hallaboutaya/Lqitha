import 'package:get_it/get_it.dart';
import '../data/repositories/found_repository.dart';
import '../data/repositories/lost_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/admin_repository.dart';
import '../data/repositories/unlock_repository.dart';
import '../data/repositories/api/api_found_repository.dart';
import '../data/repositories/api/api_lost_repository.dart';
import '../data/repositories/api/api_notification_repository.dart';
import '../data/repositories/api/api_user_repository.dart';
import '../data/repositories/api/api_admin_repository.dart';
import '../data/repositories/api/api_unlock_repository.dart';
import '../cubits/found/found_cubit.dart';
import '../cubits/lost/lost_cubit.dart';
import '../cubits/notification/notification_cubit.dart';
import '../cubits/user_profile/user_profile_cubit.dart';
import '../cubits/admin/admin_cubit.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/locale/locale_cubit.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';
import '../config/api_config.dart';
import '../core/logging/app_logger.dart';
import '../services/notification_service.dart';
import '../cubits/admin/user_management_cubit.dart';

/// Service locator for dependency injection using get_it.
/// 
/// This centralizes all dependency registration and makes it easy to
/// provide instances throughout the app.
/// 
/// Supports switching between local SQLite and API repositories
/// based on the USE_API flag in ApiConfig.
final getIt = GetIt.instance;

/// Initialize all dependencies.
/// 
/// Call this in main() before runApp().
Future<void> setupServiceLocator() async {
  AppLogger.i('🔧 Setting up service locator...');
  AppLogger.d('🔧 USE_API mode: ${ApiConfig.USE_API}');
  
  // Register API client (singleton)
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  
  // Register repositories based on USE_API flag
  if (ApiConfig.USE_API) {
    AppLogger.i('🌐 Registering API repositories...');
    
    // API implementations (extend base classes)
    getIt.registerLazySingleton<FoundRepository>(() {
      final repo = ApiFoundRepository();
      return repo as FoundRepository;
    });
    getIt.registerLazySingleton<LostRepository>(() {
      final repo = ApiLostRepository();
      return repo as LostRepository;
    });
    getIt.registerLazySingleton<NotificationRepository>(() {
      final repo = ApiNotificationRepository();
      return repo as NotificationRepository;
    });
    getIt.registerLazySingleton<UserRepository>(() {
      final repo = ApiUserRepository();
      return repo as UserRepository;
    });
    getIt.registerLazySingleton<AdminRepository>(() {
      final repo = ApiAdminRepository();
      return repo as AdminRepository;
    });
    getIt.registerLazySingleton<UnlockRepository>(() {
      final repo = ApiUnlockRepository();
      return repo as UnlockRepository;
    });
  } else {
    AppLogger.i('💾 Registering local SQLite repositories...');
    
    // Local SQLite implementations (current)
    getIt.registerLazySingleton<FoundRepository>(() => FoundRepository());
    getIt.registerLazySingleton<LostRepository>(() => LostRepository());
    getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepository());
    getIt.registerLazySingleton<UserRepository>(() => UserRepository());
    getIt.registerLazySingleton<AdminRepository>(() => AdminRepository());
    // Note: Local implementation for UnlockRepository not needed if using API mostly, 
    // but for consistency we could add it. For now let's just use the repo as is.
    getIt.registerLazySingleton<UnlockRepository>(() => ApiUnlockRepository()); 
  }
  
  // Register services (singletons)
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  
  // Register cubits (factory - new instance each time)
  // Note: Cubits are typically provided via BlocProvider in the widget tree
  // but we can also register them here if needed for testing or other purposes
  getIt.registerFactory<FoundCubit>(() => FoundCubit(getIt<FoundRepository>(), getIt<UnlockRepository>()));
  getIt.registerFactory<LostCubit>(() => LostCubit(getIt<LostRepository>(), getIt<UnlockRepository>()));
  getIt.registerFactory<NotificationCubit>(() => NotificationCubit(getIt<NotificationRepository>()));
  getIt.registerFactory<AdminCubit>(() => AdminCubit(getIt<AdminRepository>()));
  getIt.registerFactory<UserManagementCubit>(() => UserManagementCubit(getIt<AdminRepository>()));
  
  // Register AuthCubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(
    userRepository: getIt<UserRepository>(),
    authService: getIt<AuthService>(),
  ));
  
  // Register UserProfileCubit with default userId (will be overridden in BlocProvider)
  getIt.registerFactoryParam<UserProfileCubit, String, void>(
    (userId, _) => UserProfileCubit(
      repository: getIt<UserRepository>(),
      userId: userId,
    ),
  );
  
  // Register LocaleCubit (Singleton for global state)
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  
  AppLogger.i('✅ Service locator setup complete!');
}


