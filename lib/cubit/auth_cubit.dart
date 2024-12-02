
//newwwwwwwwwwest


import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repo.dart';

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
  String currentCaptcha = '';

  AuthCubit(this.authRepository) : super(AuthInitial(_generateRandomCaptcha())) {
    currentCaptcha = (state as AuthInitial).captcha;  // Store initial captcha
  }

  static String _generateRandomCaptcha() {
    return (1000 + Random().nextInt(9000)).toString();  // 4-digit captcha
  }

  void regenerateCaptcha() {
    currentCaptcha = _generateRandomCaptcha();
    emit(AuthInitial(currentCaptcha));
  }

  Future<void> login(String email, String password, String captchaInput, bool rememberMe) async {
    if (captchaInput != currentCaptcha) {
      emit(AuthFailure('Invalid Captcha'));
      regenerateCaptcha();  // Refresh captcha on failure
      return;
    }

    emit(AuthLoading());
    try {
        final role = await authRepository.checkRole(email);
              bool isAuthenticated = await authRepository.login(email, password);


      if (email=='admin@gmail.com') {
        emit(AdminAuthenticated());
      } 
      //else {
      //   emit(UserAuthenticated());
      // }
      if (isAuthenticated) {
        if (rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('email', email);
          prefs.setString('password', password);
        }
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()}'));
      regenerateCaptcha();  // Refresh captcha after an error
    }
  }

}

