import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/parking_lot_model.dart';
import '../repository/admin_repo.dart';
import '../states/admin_state.dart';
import 'auth_cubit.dart';
import 'user_cubit.dart';

class AdminAuthenticated extends AdminState {}

class AdminFailure extends AdminState {
  final String errorMessage;
  AdminFailure(this.errorMessage);
}

class AdminCubit extends Cubit<AdminState> {
  // final AuthRepository authRepository;
  final AdminRepository adminRepository;

  AdminCubit(this.adminRepository) : super(AdminInitial());

  Future<void> createParkingLot(
      String name, int rank, Map<String, int> nSlotsKey) async {
    if (name.isEmpty || rank <= 0 || nSlotsKey.isEmpty) {
      emit(ParkingLotCreationFailure(
          'All fields are required, and rank must be positive.'));
      return;
    }

    final parkingLot = ParkingLot(name: name, rank: rank, nSlotsKey: nSlotsKey);

    emit(ParkingLotLoading());
    try {
      await adminRepository.createParkingLot(parkingLot);
      emit(ParkingLotCreated());
    } catch (e) {
      emit(ParkingLotCreationFailure(e.toString()));
    }
  }

  //login as an admin
// String currentCaptcha='';
//   Future<void> login(BuildContext context, String email, String password,
//       String captchaInput, bool rememberMe) async {
//     if (captchaInput != currentCaptcha) {
//       emit(AdminFailure('Invalid Captcha'));
//       // regenerateCaptcha(); // Refresh captcha on failure
//       return;
//     }

//     // emit(AuthLoading());
//     try {
//       final role =
//           await adminRepository.checkRole(email); // Check role (admin/user)
//       bool isAuthenticated = await adminRepository.login(email, password);

//       if (email == 'admin@gmail.com') {
//         emit(AdminAuthenticated());
//         print('@@@@@@@@@@@@@@@@@trueeeeeee');
//       } else {
//         print('userrrrrrrrrrrrrrrrrrrrr'); // User role detected
//       }

//       if (isAuthenticated) {
//         if (rememberMe) {
//           final prefs = await SharedPreferences.getInstance();
//           prefs.setString('email', email);
//           prefs.setString('password', password);
//         }
//         // Fetch and load the user profile
//         //  context.read<UserCubit>().fetchUserProfile();

//         // Retrieve the current user's ID and fetch their profile
//         // final userId = FirebaseAuth
//         //     .instance.currentUser?.uid; // Get the userId from Firebase
//         // if (userId != null) {
//         //   await userCubit.fetchUserProfile();
//         //   print('profile milgyi');
//         //   emit(AuthSuccess());
//         // } else {
//         //   print('@@@@@@@@@@@@@@@${e.toString()}');
//         //   emit(AuthFailure('Failed to retrieve user ID'));
//         // }
//         // Fetch user data after successful login
//         // await userCubit.fetchUserProfile(); // **Updated**

//         // Fetch user profile after login using context
//         final userId = FirebaseAuth.instance.currentUser?.uid;
//         if (userId != null) {
//           // Use context to call UserCubit
//           context.read<UserCubit>().fetchUserProfile();
//         }

//         emit(AuthSuccess());
//       } else {
//         emit(AuthFailure('Invalid email or password'));
//       }
//     } catch (e) {
//       emit(AuthFailure('Login failed: ${e.toString()}'));
//       regenerateCaptcha(); // Refresh captcha after an error
//     }
//   }
}
