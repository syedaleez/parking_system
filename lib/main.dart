import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/auth_cubit.dart';
import 'navigation/route_generator.dart';
import 'repository/auth_repo.dart';
// import 'repository/auth_repository.dart';
import 'screens/signIn_signUp/SignInScreen.dart';
// import 'screens/sign_in_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepository),
      child: MaterialApp(
        title: 'Parking System',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: 
         {
          '/login': (context) => SignInScreen(),
          // '/home': (context) => HomePage(), // Add home page navigation
        },

        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
