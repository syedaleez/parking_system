import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/parking_lot_model.dart';
import '../../repository/admin_repository.dart';
import 'admin_state.dart';

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
      log("All fields are reuired");
      return;
    }

    final parkingLot = ParkingLot(name: name, rank: rank, nSlotsKey: nSlotsKey);

    emit(ParkingLotCreated());
    try {
      await adminRepository.createParkingLot(parkingLot);
      emit(ParkingLotCreated());
      log("parking lot createdddddddddddddddddddddd");
    } catch (e) {
      emit(ParkingLotCreationFailure(

          //  print("faileddddddddddddddd");
          e.toString()));
      log("failedddddddddddddd");
    }
  }
}
