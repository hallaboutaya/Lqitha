import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/locale/locale_cubit.dart';
import 'cubits/locale/locale_state.dart';

import 'screens/auth/login/login_screen.dart';
import 'theme/app_colors.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import 'services/database_seeder.dart';
import 'services/service_locator.dart';
import 'services/notification_service.dart';
import 'core/logging/app_logger.dart';

void main() async {
  AppLogger.i('🚀 App starting...');
  WidgetsFlutterBinding.ensureInitialized();
  
  AppLogger.i('🔧 Initializing dependency injection...');
  // Initialize dependency injection
  await setupServiceLocator();
  
  AppLogger.i('🌱 Starting database seeding...');
  // Seed database with test data
  await DatabaseSeeder.seedDatabase();

  AppLogger.i('🔔 Initializing notification service...');
  // Initialize FCM
  try {
    await getIt<NotificationService>().initialize();
  } catch (e) {
    AppLogger.e('⚠️ Failed to initialize notification service', e);
  }
  
  AppLogger.i('▶️ Running app...');
  runApp(const LqithaApp());
}

class LqithaApp extends StatelessWidget {
  const LqithaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LocaleCubit>(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Lqitha',
            debugShowCheckedModeBanner: false,
            // Localization configuration
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('fr'), // French
              Locale('ar'), // Arabic
            ],
            locale: state.locale, // Dynamic locale from state
            // RTL support for Arabic - MaterialApp handles this automatically
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first; // Default to English
            },
            theme: ThemeData(
              primaryColor: AppColors.primaryPurple,
              scaffoldBackgroundColor: AppColors.backgroundStart,
              fontFamily: 'Arimo',
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryPurple,
                primary: AppColors.primaryPurple,
                secondary: AppColors.primaryOrange,
              ),
            ),
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
