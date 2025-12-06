import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cubits/admin/admin_cubit.dart';
import 'data/repositories/admin_repository.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AdminRepository(),
      child: BlocProvider(
        create: (context) => AdminCubit(context.read<AdminRepository>()),
        child: MaterialApp(
          title: 'Lqitha Admin',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
          initialRoute: '/admin',
          routes: {'/admin': (context) => const AdminDashboardScreen()},
        ),
      ),
    );
  }
}
