import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/auth/login/login_screen.dart';
import 'theme/app_colors.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import 'services/database_seeder.dart';
import 'services/service_locator.dart';

void main() async {
  print('🚀 App starting...');
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔧 Initializing dependency injection...');
  // Initialize dependency injection
  await setupServiceLocator();
  
  print('🌱 Starting database seeding...');
  // Seed database with test data
  await DatabaseSeeder.seedDatabase();
  
  print('▶️ Running app...');
  runApp(const LqithaApp());
}

class LqithaApp extends StatelessWidget {
  const LqithaApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      locale: const Locale('en'), // Default locale
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
  }
}
