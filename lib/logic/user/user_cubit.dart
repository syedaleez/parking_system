import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/user_repository.dart';
import '../parking/parking_cubit.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  final userId = FirebaseAuth.instance.currentUser?.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;

        // Convert Timestamp to DateTime if present
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
        }

        log('Fetched User Data: $data'); // Debug log
        emit(UserDataLoaded(data)); // Emit the correct state with user data
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      emit(UserError(
          'Failed to load profile: ${e.toString()}')); // Ensure error state is emitted
    }
  }

  //exit

  /// Show Exit Confirmation Dialog
  void showExitDialog(BuildContext context, int slotId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Slot'),
          content: const Text('Are you sure you want to exit this slot?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Trigger exit logic
                await context.read<ParkingCubit>().exitSlot(slotId);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void completeExit(int slotId) {
    emit(ParkingExitConfirmed(slotId));
  }
}
