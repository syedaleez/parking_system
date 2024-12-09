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
      print("All fields are reuired");
      return;
    }

    final parkingLot = ParkingLot(name: name, rank: rank, nSlotsKey: nSlotsKey);

    emit(ParkingLotLoading());
    try {
      await adminRepository.createParkingLot(parkingLot);
      emit(ParkingLotCreated());
      print("parking lot createdddddddddddddddddddddd");
    } catch (e) {
      emit(ParkingLotCreationFailure(

          //  print("faileddddddddddddddd");
          e.toString()));
      print("failedddddddddddddd");
    }
  }
}
