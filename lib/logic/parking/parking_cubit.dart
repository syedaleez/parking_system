//new today for parking slotsss

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../models/parking_slot_model.dart';
import 'parking_state.dart';

// class ParkingState {}

// class ParkingLoading extends ParkingState {}

// class ParkingSuccess extends ParkingState {
//   final String message;

//   ParkingSuccess(this.message);
// }

// class ParkingPlateNumberFetched extends ParkingState {
//   final String numberPlate;
//   ParkingPlateNumberFetched(this.numberPlate);
// }

// class NotificationUpdated extends ParkingState {
//   final int notificationCount;
//   NotificationUpdated(this.notificationCount);
// }

// class ParkingLoaded extends ParkingState {
//   final List<ParkingSlot> parkingSlots;

//   ParkingLoaded(
//     this.parkingSlots,
//   ); // Named parameters
// }

// class BookedSlotsLoaded extends ParkingState {
//   final List<ParkingSlot> bookedSlots;
//   BookedSlotsLoaded(this.bookedSlots);
// }

// class AdminBookedSlotsLoaded extends ParkingState {
//   final List<Map<String, dynamic>> bookedSlots;

//   AdminBookedSlotsLoaded(this.bookedSlots);
// }

// class ParkingError extends ParkingState {
//   final String errorMessage;
//   ParkingError(this.errorMessage);
// }

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingLoading());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<ParkingSlot> slots = [];
  Set<int> bookedSlotIds = {}; // Keep track of booked slots globally
  int notificationCount = 0;

  //updated monitor wala function

  Future<void> fetchAndMonitorSlots() async {
    try {
      emit(ParkingLoading());

      // Fetch slots from API
      final response = await http
          .get(Uri.parse('http://192.168.10.23:5005/parking_lot/status'))
          .timeout(const Duration(seconds: 35));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] is List) {
          slots = (data['data'] as List)
              .map((json) => ParkingSlot.fromJson(json))
              .toList();

          // Listen to Firestore for global booked slots and update slot availability
          _firestore.collection('booked_slots').snapshots().listen((snapshot) {
            bookedSlotIds =
                snapshot.docs.map((doc) => doc['slotId'] as int).toSet();
            _updateSlotAvailability();
          });

          // emit(ParkingLoaded(slots,)),
          emit(ParkingLoaded(
            slots,
          ));
        } else {
          emit(ParkingError('Invalid format of slot data.'));
        }
      } else {
        emit(ParkingError(
            'Failed to load parking slots. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(
          ParkingError('Error fetching and monitoring slots: ${e.toString()}'));
    }
  }

//function monitor

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
          parkingLotRank: data['parkingLotRank'] ?? 0,
          slotSizeId: data['slotSizeId'] ?? 0,
          data: (data['vehicleData'] as List<dynamic>? ?? [])
              .map((item) => int.tryParse(item.toString()) ?? 0)
              .toList(),
          //plate number fetchhh
          plateNumber: data['plateNumber'] as String? ?? 'Unknown',

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

  void listenForNewBookings() {
    FirebaseFirestore.instance
        .collection('booked_slots')
        .snapshots()
        .listen((snapshot) {
      final newNotifications = snapshot.docs.length;
      if (newNotifications > notificationCount) {
        notificationCount = newNotifications; // Update the count
        emit(NotificationUpdated(notificationCount));
      }
    });
  }

  //fetch all booked slotss for admin
  Future<void> fetchAllBookedSlots() async {
    try {
      emit(ParkingLoading());
      // Fetch booked slots
      final bookedSlotsSnapshot =
          await FirebaseFirestore.instance.collection('booked_slots').get();

      final List<Map<String, dynamic>> bookedSlots = [];

      // Loop through each booked slot and fetch user details
      for (var doc in bookedSlotsSnapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String;

        // Fetch user details
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        final userName = userDoc.data()?['fullName'] ?? 'Unknown User';
        final userEmail = userDoc.data()?['email'] ?? 'Unknown Email';

        bookedSlots.add({
          'slotId': data['slotId'],
          'plateNumber': data['plateNumber'],
          'timestamp': (data['timestamp'] as Timestamp?)?.toDate(),
          'userName': userName,
          'userEmail': userEmail,
        });
      }

      emit(AdminBookedSlotsLoaded(bookedSlots));
    } catch (e) {
      emit(ParkingError('Failed to fetch booked slots: $e'));
    }
  }

  // / Book a Slot
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
        log('Vehicle parked successfully.');
        final responseData = json.decode(response.body);

        final ticketId = responseData['ticketId'];

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
            'ticketId': ticketId,
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

  //function to fetch the plateNumber to show in dialog of booking slot

  Future<void> fetchPlateNumber(String userId) async {
    emit(ParkingLoading());
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final numberPlate = userDoc.get('plateNumber') as String?;
        if (numberPlate != null) {
          emit(ParkingPlateNumberFetched(numberPlate));
        } else {
          emit(ParkingError('Plate number not found for the user.'));
        }
      } else {
        emit(ParkingError('User not found.'));
      }
    } catch (e) {
      emit(ParkingError('Error fetching plate number: $e'));
    }
  }

  //plate function end here
  //exit slot function

  Future<void> exitSlot(int slotId) async {
    try {
      emit(ParkingLoading());

      // API Call to exit vehicle
      final response = await http.post(
        Uri.parse('http://192.168.10.23:5005/vehicle/exit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'ticketId': slotId}), // Using slotId
      );

      if (response.statusCode == 200) {
        await FirebaseFirestore.instance
            .collection('booked_slots')
            .doc(slotId.toString())
            .delete();

        //and and
        final userId =
            FirebaseAuth.instance.currentUser?.uid; // Get the user ID
        if (userId != null) {
          await FirebaseFirestore.instance
              .collection('user_bookings')
              .doc(userId)
              .collection('bookings')
              .doc(slotId.toString())
              .delete();
        } else {
          log('data not deleted from the booked slots');
        }

        log('Vehicle exited successfully.');
        fetchBookedSlots();

        // Update the local parking slots to mark the slot as not reserved
        final index = slots.indexWhere((slot) => slot.id == slotId);
        if (index != -1) {
          slots[index] = slots[index].copyWith(isReserved: false);
        }

        emit(ParkingSuccess('Slot exited successfully.'));
        fetchAndMonitorSlots(); // Refresh slots on home tab
      } else {
        emit(ParkingError('Failed to exit slot: ${response.body}'));
      }
    } catch (e) {
      emit(ParkingError('Error during exit: $e'));
    }
  }
}

extension on ParkingSlot {}
