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

          //new container
          child: Container(
            decoration: BoxDecoration(
              gradient: slot.isReserved
                  ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 247, 96, 96),
                        Color.fromARGB(255, 223, 8, 8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 129, 241, 135),
                        Color.fromARGB(255, 1, 29, 9)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(16), // More rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Enhanced shadow
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: slot.isReserved ? 0.3 : 0.2,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      slot.isReserved
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Slot ${slot.id}', // Adding dynamic slot identifier
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      slot.isReserved ? 'Reserved' : 'Available',
                      style: TextStyle(
                        color: slot.isReserved
                            ? const Color.fromARGB(255, 217, 238, 192)
                            : const Color.fromARGB(255, 220, 230, 220),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      slot.data.join(', '), // Displaying additional slot data
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //end new container
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
