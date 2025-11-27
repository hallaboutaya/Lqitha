import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/admin_provider.dart';
import 'screens/auth/login/login_screen.dart';
import 'theme/app_colors.dart';

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
