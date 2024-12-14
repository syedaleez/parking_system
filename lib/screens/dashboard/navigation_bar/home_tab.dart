import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/parking/parking_cubit.dart';
import '../../../logic/parking/parking_state.dart';
import '../../../models/parking_slot_model.dart';
import 'parking_form_state.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    context.read<ParkingCubit>().fetchAndMonitorSlots();
    return Scaffold(
      // appBar: AppBar(title: Text('Home')),
      body: BlocConsumer<ParkingCubit, ParkingState>(
        listener: (context, state) {
          if (state is ParkingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is ParkingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ParkingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ParkingLoaded) {
            List<ParkingSlot> bikeSlots =
                state.parkingSlots.where((s) => s.slotSizeId == 1).toList();
            List<ParkingSlot> carSlots =
                state.parkingSlots.where((s) => s.slotSizeId == 2).toList();
            List<ParkingSlot> truckSlots =
                state.parkingSlots.where((s) => s.slotSizeId == 3).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Bike Slots'),
                  ParkingSlotList(slots: bikeSlots),
                  const SectionHeader(title: 'Car Slots'),
                  ParkingSlotList(slots: carSlots),
                  const SectionHeader(title: 'Truck Slots'),
                  ParkingSlotList(slots: truckSlots),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No parking slots available.'));
          }
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class ParkingSlotList extends StatelessWidget {
  final List<ParkingSlot> slots;

  const ParkingSlotList({required this.slots, super.key});

  @override
  Widget build(BuildContext context) {
    // final userId=getCurrentUser();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Change based on your UI requirements
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return GestureDetector(
          onTap: () {
            if (!slot.isReserved) {
              _showSlotDetails(context, slot);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Slot is already booked.')),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: slot.isReserved ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Subtle shadow
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: slot.isReserved
                      ? const Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 60,
                            color: Colors.white,
                          ),
                        )
                      : const Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.cancel_outlined,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Slot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slot.data.join(', '),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSlotDetails(BuildContext context, ParkingSlot slot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Your Booking'),
          content: ParkingForm(
            slotId: slot.id,
            vehicleSizeId: slot
                .slotSizeId, // Asssuming slotSizeId is the vehicleSizeId because of API
          ),
        );
      },
    );
  }
}
// void showBookingDialog(BuildContext context,  plateNumber, ParkingSlot slot) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Confirm Booking'),
//         content: Text('Your number plate: $plateNumber\nSlot: $slot\nProceed?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close the dialog
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Book the slot
//               FirebaseFirestore.instance
//                   .collection('booked_slots')
//                   .add({'number_plate': plateNumber, 'slot': slot});
//               Navigator.pop(context); // Close the dialog
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Slot $slot booked successfully!')),
//               );
//             },
//             child: Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }
// Future<String?> fetchPlateNumber(String userId) async {
//   try {
//     // Fetch user document from Firestore
//     DocumentSnapshot userDoc =
//         await FirebaseFirestore.instance.collection('users').doc(userId).get();

//     if (userDoc.exists) {
//       // Extract the plate number field
//       // final numberPlate = fetchPlateNumber(userId);
//       showBookingDialog(context, numberPlate, slots);
//       return userDoc.get('plateNumber') as String?;
      
//     } 
//     else {
//       print('User document not found');
//       return null;
//     }
//   } catch (e) {
//     print('Error fetching plate number: $e');
//     return null;
//   }
// }

