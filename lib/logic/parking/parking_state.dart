import '../../models/parking_slot_model.dart';

class ParkingState {}

class ParkingLoading extends ParkingState {}

class ParkingSuccess extends ParkingState {
  final String message;

  ParkingSuccess(this.message);
}

class ParkingPlateNumberFetched extends ParkingState {
  final String numberPlate;
  ParkingPlateNumberFetched(this.numberPlate);
}

class NotificationUpdated extends ParkingState {
  final int notificationCount;
  NotificationUpdated(this.notificationCount);
}

class ParkingLoaded extends ParkingState {
  final List<ParkingSlot> parkingSlots;

  ParkingLoaded(
    this.parkingSlots,
  ); // Named parameters
}

class BookedSlotsLoaded extends ParkingState {
  final List<ParkingSlot> bookedSlots;
  BookedSlotsLoaded(this.bookedSlots);
}

class AdminBookedSlotsLoaded extends ParkingState {
  final List<Map<String, dynamic>> bookedSlots;

  AdminBookedSlotsLoaded(this.bookedSlots);
}

class ParkingError extends ParkingState {
  final String errorMessage;
  ParkingError(this.errorMessage);
}
