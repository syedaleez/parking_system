// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

// import '../models/parkingSlot_model.dart';

// class ParkingState {}

// class ParkingLoading extends ParkingState {}

// class ParkingSuccess extends ParkingState {
//   final String message;
//   ParkingSuccess(this.message);
// }

// class ParkingLoaded extends ParkingState {
//   final List<ParkingSlot> parkingSlots;
//   //

//   ParkingLoaded(this.parkingSlots);
// }

// class BookedSlotsLoaded extends ParkingState {
//   // New State
//   final List<ParkingSlot> bookedSlots;
//   BookedSlotsLoaded(this.bookedSlots);
//   //  final ParkingRepository parkingRepository;
// }

// class ParkingError extends ParkingState {
//   final String errorMessage;

//   ParkingError(this.errorMessage);
// }

// class ParkingCubit extends Cubit<ParkingState> {
//   ParkingCubit() : super(ParkingLoading());
//   List<ParkingSlot> slots = [];
// Set<int> bookedSlotIds = {}; //used to set it globally
//   // function to get APi in  UI
//   Future<void> fetchParkingSlots() async {
//     try {

//       final response = await http
//           .get(Uri.parse('http://192.168.10.23:5005/parking_lot/status'))
//           .timeout(Duration(seconds: 15));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['data'] is List) {
//           slots = (data['data'] as List)
//               .map((json) => ParkingSlot.fromJson(json))
//               .toList();
//           emit(ParkingLoaded(slots)); // Emit the loaded slots state
//         } else {
//           emit(ParkingError('format og data is wrong'));
//         }
//       } else {
//         emit(ParkingError(
//             'Failed to load parking slots... Status code: ${response.statusCode}'));
//       }
//     } catch (e) {
//       //error ko String mai convert karo
//       emit(ParkingError('Error: ${e.toString()}'));
//     }
//   }
// //method for fetching slots that are vooked

//   Future<void> fetchBookedSlots(dynamic parkingRepository) async {
//     emit(ParkingLoading());
//     try {
//       final bookedSlots =
//           await parkingRepository.getBookedSlots(); // New API call method
//       emit(BookedSlotsLoaded(bookedSlots));
//     } catch (e) {
//       emit(ParkingError('Failed to load booked slots: ${e.toString()}'));
//     }
//   }

//   //newwwwwwwwwww
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> postVehicleData(
//       int slotId, String plateNumber, int vehicleSizeId) async {
//     try {
//       emit(ParkingLoading());

//       final response = await http.post(
//         Uri.parse('http://192.168.10.23:5005/vehicle/park'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'vehicleSizeId': vehicleSizeId,
//           'plateNumber': plateNumber,
//           'parkingLotId': slotId,
//         }),
//       );

//       if (response.statusCode == 201) {
//         print('@@@@@@@vehicle parked successfullyyyy');
//         // Update the slot status locally
//         final index = slots.indexWhere((slot) => slot.id == slotId);
//         if (index != -1) {
//           slots[index] = slots[index].copyWith(isReserved: true);
//         }
//         emit(ParkingSuccess('Vehicle parked successfully'));

//         //firebase workkkkkkkkkkkkkkkkkkkk

//         final userId = _firebaseAuth.currentUser?.uid;
//         if (userId != null) {
//           print('@@@@@@@@enter to add in firebase');
//           final bookingRef = _firestore
//               .collection('user_bookings')
//               .doc(userId)
//               .collection('bookings')
//               .doc();

//           await bookingRef.set({
//             'parkingLotId': slotId,
//             'slotId': slotId,
//             'plateNumber': plateNumber,
//             'timestamp': FieldValue.serverTimestamp(),
//           });

//           emit(ParkingSuccess('Vehicle parked and saved successfully.'));
//         } else {
//           emit(ParkingError('User not logged in.'));
//         }

//         //firebase work enddddddddddddddddddddd
//         fetchParkingSlots();
//       } else {
//         emit(ParkingError('Failed to park vehicle'));
//       }
//     } catch (e) {
//       emit(ParkingError('Error parking vehicle: $e'));
//     }
//   }
// }

// extension on ParkingSlot {
//   ParkingSlot copyWith({bool? isReserved}) {
//     return ParkingSlot(
//       id: this.id,
//       parkingLotId: this.parkingLotId,
//       parkingLotRank: this.parkingLotRank,
//       slotSizeId: this.slotSizeId,
//       data: this.data,
//       createdAt: this.createdAt,
//       updatedAt: this.updatedAt,
//       isReserved: isReserved ?? this.isReserved,
//     );
//   }
// }

//new today for parking slotsssssssssssssssssssssssssssssssssssssssssssssssss

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  ParkingLoaded(this.parkingSlots);
}

class BookedSlotsLoaded extends ParkingState {
  final List<ParkingSlot> bookedSlots;
  BookedSlotsLoaded(this.bookedSlots);
}

class ParkingError extends ParkingState {
  final String errorMessage;
  ParkingError(this.errorMessage);
}

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingLoading());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<ParkingSlot> slots = [];
  Set<int> bookedSlotIds = {}; // Keep track of booked slots globally

  /// Fetch and Monitor Parking Slots
  Future<void> fetchAndMonitorSlots() async {
    try {
      emit(ParkingLoading());

      // Fetch slots from API
      final response = await http
          .get(Uri.parse('http://192.168.10.23:5005/parking_lot/status'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] is List) {
          slots = (data['data'] as List)
              .map((json) => ParkingSlot.fromJson(json))
              .toList();

          // Listen to Firestore for global booked slots
          _firestore.collection('booked_slots').snapshots().listen((snapshot) {
            bookedSlotIds =
                snapshot.docs.map((doc) => doc['slotId'] as int).toSet();
            _updateSlotAvailability();
          });

          emit(ParkingLoaded(slots));
        } else {
          emit(ParkingError('Invalid format of slot data.'));
        }
      } else {
        emit(ParkingError('Failed to load parking slots.'));
      }
    } catch (e) {
      emit(ParkingError('Error: ${e.toString()}'));
    }
  }

  /// Update Slot Availability Based on Booked Slots
  void _updateSlotAvailability() {
    final updatedSlots = slots.map((slot) {
      final isBooked = bookedSlotIds.contains(slot.id);
      return slot.copyWith(isReserved: isBooked);
    }).toList();
    emit(ParkingLoaded(updatedSlots));
  }

  //fethc booked slots function newww for slots to show in the booked slots tab

  Future<void> fetchBookedSlots() async {
    emit(ParkingLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(ParkingError('User not logged in.'));
        return;
      }

      // Fetch bookings for the user
      final snapshot = await FirebaseFirestore.instance
          .collection('user_bookings')
          .doc(userId)
          .collection('bookings')
          .get();

      // Map Firestore data to ParkingSlot objects
      final bookedSlots = snapshot.docs.map((doc) {
        final data = doc.data();
        return ParkingSlot(
          id: data['slotId'] as int? ?? 0, // Default to 0 if null
          parkingLotId:
              data['parkingLotId'] as int? ?? 0, // Default to 0 if null
          parkingLotRank: data['parkingLotRank'] ??
              0, // Adjust based on Firestore structure
          slotSizeId:
              data['slotSizeId'] ?? 0, // Adjust based on Firestore structure
          data: (data['vehicleData'] as List<dynamic>? ?? [])
              .map((item) => int.tryParse(item.toString()) ?? 0)
              .toList(), // Convert List<dynamic> to List<int>
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ??
                  DateTime.now().toIso8601String(), // Convert to String
          updatedAt:
              (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String() ??
                  DateTime.now().toIso8601String(), // Convert to String
          isReserved: data['isReserved'] ?? false, // Default to false
        );
      }).toList();

      emit(BookedSlotsLoaded(bookedSlots));
    } catch (e) {
      emit(ParkingError('Error fetching booked slots: ${e.toString()}'));
    }
  }

  //endddddddddd

  /// Book a Slot
  Future<void> bookSlot(
      int slotId, String plateNumber, int vehicleSizeId) async {
    try {
      emit(ParkingLoading());

      // API Call to park vehicle
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
        print('Vehicle parked successfully.');

        // Update global booked slots in Firestore
        final bookingRef = _firestore.collection('booked_slots').doc('$slotId');
        await bookingRef.set({
          'slotId': slotId,
          'plateNumber': plateNumber,
          'userId': _firebaseAuth.currentUser?.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update user-specific booking record
        final userId = _firebaseAuth.currentUser?.uid;
        if (userId != null) {
          final userBookingRef = _firestore
              .collection('user_bookings')
              .doc(userId)
              .collection('bookings')
              .doc('$slotId');
          await userBookingRef.set({
            'slotId': slotId,
            'plateNumber': plateNumber,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        emit(ParkingSuccess('Slot booked successfully.'));
        fetchAndMonitorSlots(); // Refresh slots
      } else {
        emit(ParkingError('Failed to park vehicle.'));
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
