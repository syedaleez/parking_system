import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/parking_lot_model.dart';
import '../repository/admin_repo.dart';
import '../states/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository adminRepository;

  AdminCubit(this.adminRepository) : super(AdminInitial());

  Future<void> createParkingLot(String name, int rank, Map<String, int> nSlotsKey) async {
    if (name.isEmpty || rank <= 0 || nSlotsKey.isEmpty) {
      emit(ParkingLotCreationFailure('All fields are required, and rank must be positive.'));
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
}
