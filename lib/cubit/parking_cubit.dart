import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/parkingSlot_model.dart';

class ParkingState {}

class ParkingLoading extends ParkingState {}

class ParkingLoaded extends ParkingState {
  final List<ParkingSlot> parkingSlots;

  ParkingLoaded(this.parkingSlots);
}

class ParkingError extends ParkingState {
  final String errorMessage;
  
  ParkingError(this.errorMessage);
}

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingLoading());

  // Fetch parking slots from API
  // Future<void> fetchParkingSlots() async {
  //   try {
  //     final response = await http.get(Uri.parse('http://192.168.10.23:5005/parking_lot/status'));

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       List<ParkingSlot> slots = data.map((json) => ParkingSlot.fromJson(json)).toList();
  //       emit(ParkingLoaded(slots));
  //     } else {
  //       emit(ParkingError('Failed to load parking slots'));
  //     }
  //   } catch (e) {
  //     emit(ParkingError(e.toString()));
  //   }
  // }



Future<void> fetchParkingSlots() async {
  try {
    // Sending the HTTP request with a timeout of 30 seconds
    final response = await http.get(Uri.parse('http://192.168.10.23:5005/parking_lot/status'))
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      // Decode the JSON response
      final data = json.decode(response.body);

      // Check if the 'data' key exists and is a list
      if (data['data'] is List) {
        // Map the list of JSON objects to a list of ParkingSlot objects
        List<ParkingSlot> slots = (data['data'] as List)
            .map((json) => ParkingSlot.fromJson(json))
            .toList();
        emit(ParkingLoaded(slots));  // Emit the loaded slots state
      } else {
        // If the 'data' field is not in the expected format
        emit(ParkingError('Data is not in the expected format'));
      }
    } else {
      // Handle unsuccessful response
      emit(ParkingError('Failed to load parking slots. Status code: ${response.statusCode}'));
    }
  } catch (e) {
    // Catch any exception (e.g., network error, timeout) and emit error state
    emit(ParkingError('Error: ${e.toString()}'));
  }
}






  // Book a parking slot
  Future<void> bookSlot(ParkingSlot slot) async {
    // Update the slot's reservation status (could be a network request to update on the server)
    final updatedSlot = slot.copyWith(isReserved: true);

    // Normally here you would make an API call to update the status of the slot.
    await Future.delayed(Duration(seconds: 1)); // Simulate a delay

    // Emit the updated state with the slot being reserved
    emit(ParkingLoaded(List.from(state is ParkingLoaded ? (state as ParkingLoaded).parkingSlots : [])
        ..removeWhere((s) => s.id == slot.id)
        ..add(updatedSlot)));
  }
}

extension on ParkingSlot {
  ParkingSlot copyWith({bool? isReserved}) {
    return ParkingSlot(
      id: this.id,
      parkingLotId: this.parkingLotId,
      parkingLotRank: this.parkingLotRank,
      slotSizeId: this.slotSizeId,
      data: this.data,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      isReserved: isReserved ?? this.isReserved,
    );
  }
}
