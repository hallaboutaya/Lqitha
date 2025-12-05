import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'providers/admin_provider.dart';
import 'screens/auth/login/login_screen.dart';
import 'theme/app_colors.dart';

// Repositories & Cubits
import 'data/repositories/user_repository.dart';
import 'logic/cubit/users/user_profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LqithaApp());
}

class LqithaApp extends StatelessWidget {
  const LqithaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserProfileCubit(
            repository: UserRepository(), // your SQLite repository
            userId: '1', // current logged-in user ID as String
          )..loadProfile(),
        ),
      ],
      child: ChangeNotifierProvider(
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
      ),
    );
  }
}
