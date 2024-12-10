class AdminState {}

class AdminInitial extends AdminState {}

class ParkingLotLoading extends AdminState {}

class ParkingLotCreated extends AdminState {}

class ParkingLotCreationFailure extends AdminState {
  final String error;
  ParkingLotCreationFailure(this.error);
}

class ParkingSpaceDefined extends AdminState {}

class ParkingSpaceDefinitionFailure extends AdminState {
  final String error;
  ParkingSpaceDefinitionFailure(this.error);
}
