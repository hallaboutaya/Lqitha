import 'package:flutter/widgets.dart';
import 'signup/signup_screen.dart';

class AuthRoutes {
  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    SignupScreen.routeName: (context) => const SignupScreen(),
  };
}


