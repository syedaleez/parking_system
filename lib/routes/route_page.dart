import 'package:flutter/material.dart';
import 'package:parking_system/routes/route_name.dart';
import 'package:parking_system/screens/admin_pannel/view_user_details.dart';
import 'package:parking_system/screens/admin_pannel/admin_home_screen.dart';
import 'package:parking_system/screens/admin_pannel/notification_screen.dart';
import 'package:parking_system/screens/dashboard/home_screen.dart';

import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/splash/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case adminHome:
        return MaterialPageRoute(builder: (_) => const AdminHome());
      case viewUser:
        return MaterialPageRoute(builder: (_) => const ViewUserDetails());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page not found')),
        );
      },
    );
  }
}
