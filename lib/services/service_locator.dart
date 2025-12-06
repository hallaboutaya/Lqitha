import 'package:get_it/get_it.dart';
import '../data/repositories/found_repository.dart';
import '../data/repositories/lost_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/admin_repository.dart';
import '../cubits/found/found_cubit.dart';
import '../cubits/lost/lost_cubit.dart';
import '../cubits/notification/notification_cubit.dart';
import '../cubits/user_profile/user_profile_cubit.dart';
import '../cubits/admin/admin_cubit.dart';

/// Service locator for dependency injection using get_it.
/// 
/// This centralizes all dependency registration and makes it easy to
/// provide instances throughout the app.
final getIt = GetIt.instance;

/// Initialize all dependencies.
/// 
/// Call this in main() before runApp().
Future<void> setupServiceLocator() async {
  // Register repositories (singletons)
  getIt.registerLazySingleton<FoundRepository>(() => FoundRepository());
  getIt.registerLazySingleton<LostRepository>(() => LostRepository());
  getIt.registerLazySingleton<NotificationRepository>(() => NotificationRepository());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<AdminRepository>(() => AdminRepository());
  
  // Register cubits (factory - new instance each time)
  // Note: Cubits are typically provided via BlocProvider in the widget tree
  // but we can also register them here if needed for testing or other purposes
  getIt.registerFactory<FoundCubit>(() => FoundCubit(getIt<FoundRepository>()));
  getIt.registerFactory<LostCubit>(() => LostCubit(getIt<LostRepository>()));
  getIt.registerFactory<NotificationCubit>(() => NotificationCubit(getIt<NotificationRepository>()));
  getIt.registerFactory<AdminCubit>(() => AdminCubit(getIt<AdminRepository>()));
  
  // Register UserProfileCubit with default userId (will be overridden in BlocProvider)
  getIt.registerFactoryParam<UserProfileCubit, String, void>(
    (userId, _) => UserProfileCubit(
      repository: getIt<UserRepository>(),
      userId: userId,
    ),
  );
}

