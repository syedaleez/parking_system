import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/cubit/admin_cubit.dart';
import 'package:parking_system/cubit/user_cubit.dart';
import 'package:parking_system/repository/admin_repo.dart';
import 'package:parking_system/repository/user_repo.dart';
import 'package:parking_system/screens/dashboard/navBar/user_profile_tab.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/parking_cubit.dart';
import 'cubit/register_cubit.dart';
import 'navigation/route_generator.dart';
import 'repository/auth_repo.dart';
import 'navigation/route_name.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final AuthRepository authRepository = AuthRepository();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(

//       create: (context) => AuthCubit(authRepository),

//       child: MaterialApp(
//         title: 'Parking System',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         initialRoute: splash,
//         // routes:
//         //  {
//         //   '/login': (context) => SignInScreen(),
//         //   // '/home': (context) => HomePage(), // Add home page navigation
//         // },

//         onGenerateRoute: RouteGenerator.generateRoute,
//         debugShowCheckedModeBanner: false,
//       )

//     );
//   }
// }

//new code for main.dart
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final AuthRepository authRepository = AuthRepository();

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthCubit>(
//           create: (context) => AuthCubit(authRepository),
//         ),
//         BlocProvider<RegisterCubit>(
//           create: (context) => RegisterCubit(authRepository),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Parking System',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         initialRoute: splash,  // Replace with your actual splash route constant
//         onGenerateRoute: RouteGenerator.generateRoute,
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  final UserCubit userCubit = UserCubit(UserRepository());
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository, userCubit),
        ),
        BlocProvider<RegisterCubit>(
          create: (context) => RegisterCubit(authRepository),
        ),
        BlocProvider<AdminCubit>(
          create: (context) => AdminCubit(AdminRepository()),
        ),
        // BlocProvider<UserCubit>(
        //   create: (context) => UserCubit(UserRepository()),
        //   // child: UserProfileTab(),
        // ),
        BlocProvider(
          create: (context) => UserCubit(userRepository),
          child: UserProfileTab(),
        ),
        // BlocProvider<ParkingCubit>(
        //   create: (context) => ParkingCubit(),
        // ),
        BlocProvider<ParkingCubit>(
          create: (context) =>
              ParkingCubit()..fetchParkingSlots(), // Fetch once
        ),
      ],
      child: MaterialApp(
        title: 'Parking System',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: splash, // Ensure `splash` is a defined route constant
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
