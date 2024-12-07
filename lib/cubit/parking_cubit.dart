import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/parkingSlot_model.dart';

class ParkingState {}

class ParkingLoading extends ParkingState {}

class ParkingSuccess extends ParkingState {
  final String message;
  ParkingSuccess(this.message);
}

class ParkingLoaded extends ParkingState {
  final List<ParkingSlot> parkingSlots;
  //

  ParkingLoaded(this.parkingSlots);
}

class BookedSlotsLoaded extends ParkingState {
  // New State
  final List<ParkingSlot> bookedSlots;
  BookedSlotsLoaded(this.bookedSlots);
  //  final ParkingRepository parkingRepository;
}

class ParkingError extends ParkingState {
  final String errorMessage;

  ParkingError(this.errorMessage);
}

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingLoading());
  List<ParkingSlot> slots = [];

  // function to get APi in the UI
  Future<void> fetchParkingSlots() async {
    try {
      // Sending the HTTP request with a timeout of 30 seconds
      final response = await http
          .get(Uri.parse('http://192.168.10.23:5005/parking_lot/status'))
          .timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] is List) {
          slots = (data['data'] as List)
              .map((json) => ParkingSlot.fromJson(json))
              .toList();
          emit(ParkingLoaded(slots)); // Emit the loaded slots state
        } else {
          emit(ParkingError('format og data is wrong'));
        }
      } else {
        emit(ParkingError(
            'Failed to load parking slots... Status code: ${response.statusCode}'));
      }
    } catch (e) {
      //error ko String mai convert karo
      emit(ParkingError('Error: ${e.toString()}'));
    }
  }
//method for fetching slots that are vooked

  Future<void> fetchBookedSlots(dynamic parkingRepository) async {
    emit(ParkingLoading());
    try {
      final bookedSlots =
          await parkingRepository.getBookedSlots(); // New API call method
      emit(BookedSlotsLoaded(bookedSlots));
    } catch (e) {
      emit(ParkingError('Failed to load booked slots: ${e.toString()}'));
    }
  }

  // Book a parking slot
  // Future<void> bookSlot(ParkingSlot slot) async {
  //   // Update the slot's reservation status (could be a network request to update on the server)
  //   final updatedSlot = slot.copyWith(isReserved: true);

  //   // Normally here you would make an API call to update the status of the slot.
  //   await Future.delayed(Duration(seconds: 1)); // Simulate a delay

  //   // Emit the updated state with the slot being reserved
  //   emit(ParkingLoaded(List.from(
  //       state is ParkingLoaded ? (state as ParkingLoaded).parkingSlots : [])
  //     ..removeWhere((s) => s.id == slot.id)
  //     ..add(updatedSlot)));

  // }

  //newwwwwwwwwww
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> postVehicleDataAndSave(
  //     int slotId, String plateNumber, int vehicleSizeId) async {
  //   emit(ParkingLoading());
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://192.168.10.23:5005/vehicle/park'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'vehicleSizeId': vehicleSizeId,
  //         'plateNumber': plateNumber,
  //         'parkingLotId': slotId,
  //       }),
  //     );

  //   if (response.statusCode == 201) {
  //     // Update Firestore with booking details
  //     final userId = _firebaseAuth.currentUser?.uid;
  //     if (userId != null) {
  //       print('@@@@@@@@enter to add in firebase');
  //       final bookingRef = _firestore
  //           .collection('user_bookings')
  //           .doc(userId)
  //           .collection('bookings')
  //           .doc();

  //       await bookingRef.set({
  //         'parkingLotId': slotId,
  //         'slotId': slotId,
  //         'plateNumber': plateNumber,
  //         'timestamp': FieldValue.serverTimestamp(),
  //       });

  //       emit(ParkingSuccess('Vehicle parked and saved successfully.'));
  //     } else {
  //       emit(ParkingError('User not logged in.'));
  //     }

  //     // Refresh parking slots
  //     fetchParkingSlots();
  //   } else {
  //     emit(ParkingError(
  //         'Failed to park vehicle. Status code: ${response.statusCode}'));
  //   }
  // } catch (e) {
  //   emit(ParkingError('Error parking vehicle: ${e.toString()}'));
  // }
  // }

  Future<void> postVehicleData(
      int slotId, String plateNumber, int vehicleSizeId) async {
    try {
      emit(ParkingLoading());

      final response = await http.post(
        Uri.parse('http://192.168.10.23:5005/vehicle/park'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'vehicleSizeId': vehicleSizeId,
          'plateNumber': plateNumber,
          'parkingLotId': slotId,
        }),
      );

      if (response.statusCode == 201) {
        print('@@@@@@@vehicle parked successfullyyyy');
        // Update the slot status locally
        final index = slots.indexWhere((slot) => slot.id == slotId);
        if (index != -1) {
          slots[index] = slots[index].copyWith(isReserved: true);
        }
        emit(ParkingSuccess('Vehicle parked successfully'));

        //firebase workkkkkkkkkkkkkkkkkkkk

        final userId = _firebaseAuth.currentUser?.uid;
        if (userId != null) {
          print('@@@@@@@@enter to add in firebase');
          final bookingRef = _firestore
              .collection('user_bookings')
              .doc(userId)
              .collection('bookings')
              .doc();

          await bookingRef.set({
            'parkingLotId': slotId,
            'slotId': slotId,
            'plateNumber': plateNumber,
            'timestamp': FieldValue.serverTimestamp(),
          });

          emit(ParkingSuccess('Vehicle parked and saved successfully.'));
        } else {
          emit(ParkingError('User not logged in.'));
        }

        //firebase work enddddddddddddddddddddd
        fetchParkingSlots();
      } else {
        emit(ParkingError('Failed to park vehicle'));
      }
    } catch (e) {
      emit(ParkingError('Error parking vehicle: $e'));
    }
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
