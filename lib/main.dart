import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/admin_provider.dart';
import 'screens/auth/login/login_screen.dart';
import 'theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const LqithaApp());
}

class LqithaApp extends StatelessWidget {
  const LqithaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminProvider(),
      child: MaterialApp(
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
      ),
    );
  }
}
