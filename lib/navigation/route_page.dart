import 'package:flutter/material.dart';
import 'package:parking_system/navigation/route_name.dart';
import 'package:parking_system/screens/admin_pannel/view_user_details.dart';
import 'package:parking_system/screens/admin_pannel/admin_home_screen.dart';
import 'package:parking_system/screens/admin_pannel/notification_screen.dart';
import 'package:parking_system/screens/dashboard/home_scree.dart';

import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/splash/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case home:
        return MaterialPageRoute(builder: (_) => homeScreen());
      case adminHome:
        return MaterialPageRoute(builder: (_) => AdminHome());
      case viewUser:
        return MaterialPageRoute(builder: (_) => ViewUserDetails());
      case notification:
        return MaterialPageRoute(builder: (_) => NotificationsScreen());

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
