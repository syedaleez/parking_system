import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/admin_repo.dart';
import '../states/admin_state.dart';


class AdminCubit extends Cubit<AdminState> {
  final AdminRepository adminRepository;

  AdminCubit(this.adminRepository) : super(AdminInitial());

  Future<void> createParkingLot(String name, String location, int capacity) async {
    if (name.isEmpty || location.isEmpty || capacity <= 0) {
      emit(ParkingLotCreationFailure('All fields are required and capacity must be positive.'));
      return;
    }
    
    emit(ParkingLotLoading());
    try {
      await adminRepository.createParkingLot(name, location, capacity);
      emit(ParkingLotCreated());
    } catch (e) {
      emit(ParkingLotCreationFailure('Failed to create parking lot: ${e.toString()}'));
    }
  }

  Future<void> defineParkingSpace(String lotId, List<String> spaces) async {
    try {
      await adminRepository.defineParkingSpaces(lotId, spaces);
      emit(ParkingSpaceDefined());
    } catch (e) {
      emit(ParkingSpaceDefinitionFailure('Failed to define spaces: ${e.toString()}'));
    }
  }
}
