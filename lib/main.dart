import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/logic/admin/admin_cubit.dart';
import 'package:parking_system/logic/user/user_cubit.dart';
import 'package:parking_system/screens/dashboard/navigation_bar/user_profile_tab.dart';
import 'dependency_injection/locator.dart';
import 'logic/authenticate/auth_cubit.dart';
import 'logic/parking/parking_cubit.dart';
import 'logic/authenticate/register_cubit.dart';
import 'routes/route_page.dart';
import 'repository/auth_repository.dart';
import 'routes/route_name.dart';

//

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            locator<AuthRepository>(),
            locator<UserCubit>(),
          ),
        ),
        BlocProvider<RegisterCubit>(
          create: (context) => RegisterCubit(locator<AuthRepository>()),
        ),
        BlocProvider<AdminCubit>(create: (context) => locator<AdminCubit>()),
        BlocProvider(
          create: (context) => locator<UserCubit>(),
          child: const UserProfileTab(),
        ),
        BlocProvider<ParkingCubit>(
          create: (context) =>
              ParkingCubit()..fetchAndMonitorSlots(), // Fetch once
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
