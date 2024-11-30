// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../repository/auth_repo.dart';
// // import '../repository/auth_repository.dart';

//  class AuthState {}
// class AuthInitial extends AuthState {}
// class AuthLoading extends AuthState {}
// class AuthSuccess extends AuthState {}
// class AuthFailure extends AuthState {
//   final String errorMessage;
//   AuthFailure(this.errorMessage);
// }

// class AuthCubit extends Cubit<AuthState> {
//   final AuthRepository authRepository;

//   AuthCubit(this.authRepository) : super(AuthInitial());

//   Future<void> login(String email, String password) async {
//     emit(AuthLoading());
//     try {
//       bool isAuthenticated = await authRepository.login(email, password);
//       if (isAuthenticated) {
//         emit(AuthSuccess());
//       } else {
//         emit(AuthFailure('Invalid email or password'));
//       }
//     } catch (e) {
//       emit(AuthFailure('Login failed: ${e.toString()}'));
//     }
//   }
// }


//newwwwwwwwwwwwww
// import 'dart:math';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../repository/auth_repo.dart';

// class AuthState {}
// class AuthInitial extends AuthState {}
// class AuthLoading extends AuthState {}
// class AuthSuccess extends AuthState {}
// class AuthFailure extends AuthState {
//   final String errorMessage;
//   AuthFailure(this.errorMessage);
// }

// class CaptchaGenerated extends AuthState {
//   final String captcha;
//   CaptchaGenerated(this.captcha);
// }

// class AuthCubit extends Cubit<AuthState> {
//   final AuthRepository authRepository;
//   String _captchaCode = '';

//   AuthCubit(this.authRepository) : super(AuthInitial()) {
//     generateCaptcha();  // Initialize captcha on creation
//   }

//   // Generate a random 6-digit captcha code
//   void generateCaptcha() {
//     _captchaCode = (Random().nextInt(900000) + 100000).toString();
//     emit(CaptchaGenerated(_captchaCode));
//   }

//   // Validate the user-entered captcha code
//   bool validateCaptcha(String userInput) {
//     return userInput.trim() == _captchaCode;
//   }

//   // Perform login with captcha validation
//   Future<void> login(String email, String password, String captchaInput) async {
//     if (!validateCaptcha(captchaInput)) {
//       emit(AuthFailure('Invalid captcha. Please try again.'));
//       generateCaptcha();  // Generate a new captcha if validation fails
//       return;
//     }

//     emit(AuthLoading());
//     try {
//       bool isAuthenticated = await authRepository.login(email, password);
//       if (isAuthenticated) {
//         emit(AuthSuccess());
//       } else {
//         emit(AuthFailure('Invalid email or password.'));
//         generateCaptcha();  // Generate a new captcha on failed login
//       }
//     } catch (e) {
//       emit(AuthFailure('Login failed: ${e.toString()}'));
//       generateCaptcha();  // Regenerate captcha on error
//     }
//   }

//   // Expose the current captcha code (for display in the UI)
//   String get captchaCode => _captchaCode;
// }



//newwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
// import 'dart:math';  // dart math is for the random number generatuin
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../repository/auth_repo.dart';
// import 'package:shared_preferences/shared_preferences.dart';


// // States
// class AuthState {}
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

// class AuthCubit extends Cubit<AuthState> {
//   final AuthRepository authRepository;
//   String currentCaptcha = '';

//   AuthCubit(this.authRepository) : super(AuthInitial(_generateRandomCaptcha()));

//   // Generates a new captcha
//   static String _generateRandomCaptcha() {
//     Random random = Random();
//     return (100000 + random.nextInt(900000)).toString();  // 6-digit captcha
//   }

//   void regenerateCaptcha() {
//     currentCaptcha = _generateRandomCaptcha();
//     emit(AuthInitial(currentCaptcha));  // Emit new captcha
//   }
// //simple wala functionnnn
//   // Future<void> login(String email, String password, String captchaInput) async {
//   //   if (captchaInput != currentCaptcha) {
//   //     emit(AuthFailure('Invalid Captcha'));
//   //     return;
//   //   }

//   //   emit(AuthLoading());
//   //   try {
//   //     bool isAuthenticated = await authRepository.login(email, password);
//   //     if (isAuthenticated) {
//   //       emit(AuthSuccess());
//   //     } else {
//   //       emit(AuthFailure('Invalid email or password'));
//   //     }
//   //   } catch (e) {
//   //     emit(AuthFailure('Login failed: ${e.toString()}'));
//   //   }
//   // }
// //firebase wala functionmnnnnnnn
//   // Future<void> login(String email, String password, bool rememberMe,String captchaInput) async {
//   //   emit(AuthLoading());
//   //   try {
//   //     bool isAuthenticated = await authRepository.login(email, password);
//   //     if (isAuthenticated) {
//   //       if (rememberMe) {
//   //         final prefs = await SharedPreferences.getInstance();
//   //         prefs.setString('email', email);
//   //         prefs.setString('password', password);  // Caution: Encrypt in real apps
//   //       }
//   //       emit(AuthSuccess());
//   //     } else {
//   //       emit(AuthFailure('Invalid email or password'));
//   //     }
//   //   } catch (e) {
//   //     emit(AuthFailure('Login failed: ${e.toString()}'));
//   //   }
//   // }

//   //  Future<void> checkRememberedUser() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   String? email = prefs.getString('email');
//   //   String? password = prefs.getString('password');
//   //   // String? Input  = prefs.getString(captchaInput);
//   //   if (email != null && password != null) {
//   //     await login(email, password, true);  // Auto-login
//   //   }
//   // }
//   //firebase wala endd




// }


//newwwwwwwwwwest


import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repo.dart';

// States
abstract class AuthState {}
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
      bool isAuthenticated = await authRepository.login(email, password);
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

