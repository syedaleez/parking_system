import 'package:flutter/material.dart';
import 'package:parking_system/navigation/route_name.dart';
import 'package:parking_system/screens/dashboard/admin_home.dart';
import 'package:parking_system/screens/dashboard/home_scree.dart';

import '../screens/signIn_signUp/SignInScreen.dart';
import '../screens/signIn_signUp/register_screen.dart';
import '../screens/splash_scree.dart/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) =>  homeScreen());
      case '/admin_home':
        return MaterialPageRoute(builder: (_) =>  AdminHome());
      // Example routes for other screens
      // case '/admin':
      //   return MaterialPageRoute(builder: (_) => AdminPanelScreen());
      // case '/customer':
      //   return MaterialPageRoute(builder: (_) => CustomerPanelScreen());
      default:
        // Return an error page for undefined routes
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(child: Text('Page not found')),
        );
      },
    );
  }
}