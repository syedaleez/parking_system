import 'package:flutter/material.dart';

import '../screens/signIn_signUp/SignInScreen.dart';
import '../screens/splash_scree.dart/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => SignInScreen());
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