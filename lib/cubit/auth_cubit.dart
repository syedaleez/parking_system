// //newwwwwwwwwwest

// import 'dart:math';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:parking_system/cubit/user_cubit.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../repository/auth_repo.dart';
// import 'parking_cubit.dart';

// // States
//  class AuthState {}
// class AuthInitial extends AuthState {
//   final String captcha;
//   AuthInitial(this.captcha);
// }
// class AuthLoading extends AuthState {}
// class AuthSuccess extends AuthState {}
// class AuthFailure extends AuthState {
//   final String errorMessage;
//   AuthFailure(this.errorMessage);
// }
// class AdminAuthenticated extends AuthState {}
// class UserAuthenticated extends AuthState {}

// class AuthCubit extends Cubit<AuthState> {
//   final AuthRepository authRepository;
//   final UserCubit userCubit;
//   String currentCaptcha = '';

//   AuthCubit(this.authRepository,this.userCubit) : super(AuthInitial(_generateRandomCaptcha())) {
//     currentCaptcha = (state as AuthInitial).captcha;  // Store initial captcha
//   }

//   static String _generateRandomCaptcha() {
//     return (1000 + Random().nextInt(9000)).toString();  // 4-digit captcha
//   }

//   void regenerateCaptcha() {
//     currentCaptcha = _generateRandomCaptcha();
//     emit(AuthInitial(currentCaptcha));
//   }

//   Future<void> login(String email, String password, String captchaInput, bool rememberMe) async {
//     if (captchaInput != currentCaptcha) {
//       emit(AuthFailure('Invalid Captcha'));
//       regenerateCaptcha();  // Refresh captcha on failure
//       return;
//     }

//     emit(AuthLoading());
//     try {
//         final role = await authRepository.checkRole(email);
//               bool isAuthenticated = await authRepository.login(email, password);

//       if (email=='admin@gmail.com') {
//         emit(AdminAuthenticated());
//       }
//       //else {
//       //   emit(UserAuthenticated());
//       // }
//       if (isAuthenticated) {
//         if (rememberMe) {
//           final prefs = await SharedPreferences.getInstance();
//           prefs.setString('email', email);
//           prefs.setString('password', password);
//         }
//         // await UserCubit.fetchUserData();
//         emit(AuthSuccess());
//       } else {
//         emit(AuthFailure('Invalid email or password'));
//       }
//     } catch (e) {
//       emit(AuthFailure('Login failed: ${e.toString()}'));
//       regenerateCaptcha();  // Refresh captcha after an error
//     }
//   }

//  Future<void> signInWithGoogle() async {
//     emit(AuthLoading());
//     try {
//       await authRepository.signInWithGoogle();
//       emit(AuthSuccess());
//     } catch (e) {
//       emit(AuthFailure(e.toString()));
//     }
//   }

// }

//chatgpt ka code updated.......................

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:parking_system/cubit/user_cubit.dart';
import 'package:parking_system/screens/dashboard/admin_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repo.dart';
// import 'parking_cubit.dart';

// States
class AuthState {}

class AuthInitial extends AuthState {
  final String captcha;
  AuthInitial(this.captcha);
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}

class AdminAuthenticated extends AuthState {}

class UserAuthenticated extends AuthState {}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final UserCubit userCubit; // Inject UserCubit to fetch user data
  String currentCaptcha = '';
  final userId = FirebaseAuth.instance.currentUser?.uid;

  // Constructor to inject AuthRepository and UserCubit
  AuthCubit(this.authRepository, this.userCubit)
      : super(AuthInitial(_generateRandomCaptcha())) {
    currentCaptcha = (state as AuthInitial).captcha; // Store initial captcha
  }

  static String _generateRandomCaptcha() {
    return (1000 + Random().nextInt(9000)).toString(); // 4-digit captcha
  }

  void regenerateCaptcha() {
    currentCaptcha = _generateRandomCaptcha();
    emit(AuthInitial(currentCaptcha));
  }

  Future<void> login(BuildContext context, String email, String password,
      String captchaInput, bool rememberMe) async {
    if (captchaInput != currentCaptcha) {
      emit(AuthFailure('Invalid Captcha'));
      regenerateCaptcha(); // Refresh captcha on failure
      return;
    }

    emit(AuthLoading());
    try {
      // final role =
      //     await authRepository.checkRole(email); // Check role (admin/user)
      bool isAuthenticated = await authRepository.login(email, password);
      final role = await authRepository.checkRole(email);
      print('Role@@@@@@: $role');

      if (role == 'admin') {
        emit(AdminAuthenticated());
        // Navigator.push(
        // context, MaterialPageRoute(builder: (context) => AdminHome()));
        Navigator.pushReplacementNamed(context, '/admin_home');
        //
        print('@@@@@@@@@@@@@@@@@trueeeeeee');
        return;
      } else {
        emit(UserAuthenticated()); // User role detected
      }

      if (isAuthenticated) {
        if (rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('email', email);
          prefs.setString('password', password);
        }
        // Fetch and load the user profile
        //  context.read<UserCubit>().fetchUserProfile();

        // Retrieve the current user's ID and fetch their profile
        // final userId = FirebaseAuth
        //     .instance.currentUser?.uid; // Get the userId from Firebase
        // if (userId != null) {
        //   await userCubit.fetchUserProfile();
        //   print('profile milgyi');
        //   emit(AuthSuccess());
        // } else {
        //   print('@@@@@@@@@@@@@@@${e.toString()}');
        //   emit(AuthFailure('Failed to retrieve user ID'));
        // }
        // Fetch user data after successful login
        // await userCubit.fetchUserProfile(); // **Updated**

        // Fetch user profile after login using context
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          // Use context to call UserCubit
          context.read<UserCubit>().fetchUserProfile();
        }

        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()}'));
      regenerateCaptcha(); // Refresh captcha after an error
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signInWithGoogle() async {
    // emit(AuthLoading());
    try {
      await authRepository.signInWithGoogle();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
