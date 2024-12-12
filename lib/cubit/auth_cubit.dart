import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/cubit/user_cubit.dart';
import 'package:parking_system/navigation/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repository.dart';

// States
class AuthState {}

class AuthInitial extends AuthState {
  final String captcha;
  AuthInitial(this.captcha);
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthAdditionalDetailsRequired extends AuthState {
  final String userId;
  AuthAdditionalDetailsRequired(this.userId);
}

class AuthProfileLoaded extends AuthState {
  final Map<String, dynamic> userData;

  AuthProfileLoaded(this.userData);
}

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
      bool isAuthenticated = await authRepository.login(email, password);
      final role = await authRepository.checkRole(email);
      print('Role@@@@@@: $role');

      if (role == 'admin') {
        emit(AdminAuthenticated());
        Navigator.pushReplacementNamed(context, adminHome);
        //
        print('trueeeeee');
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
        //

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

  // Future<void> signInWithGoogle() async {
  //   // emit(AuthLoading());
  //   try {
  //     await authRepository.signInWithGoogle();
  //     emit(AuthSuccess());
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final userCredential = await authRepository.signInWithGoogle();
      // final userId = userCredential.user!.uid;
      // // final  userDetails=   Map userDetails;
      // final userData = await authRepository.getUserDetails(userId);

      // Check if additional user details are required
      final userExists =
          await authRepository.checkUserExists(userCredential.user!.uid);

      if (!userExists) {
        emit(AuthAdditionalDetailsRequired(userCredential.user!.uid));
      } else {
        emit(AuthSuccess());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> saveAdditionalDetails(
      String userId, Map<String, dynamic> userDetails) async {
    emit(AuthLoading());
    try {
      await authRepository.saveUserDetails(userId, userDetails);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
