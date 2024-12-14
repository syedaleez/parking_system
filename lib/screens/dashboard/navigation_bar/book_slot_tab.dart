import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:shimmer/shimmer.dart';
import '../../../logic/parking/parking_cubit.dart';
import '../../../logic/parking/parking_state.dart';
import '../../../logic/user/user_cubit.dart';

class BookedSlotsTab extends StatelessWidget {
  const BookedSlotsTab({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<ParkingCubit>()
        .fetchBookedSlots(); // Trigger fetch from Firestore

    return BlocBuilder<ParkingCubit, ParkingState>(
      builder: (context, state) {
        if (state is ParkingLoading) {
          return ListView.builder(
            itemCount: 6, // Placeholder count for shimmer effect
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // Spacing around the shimmer
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 100, // Height of the shimmer box
                ),
              ),
            ),
          );
        } else if (state is BookedSlotsLoaded) {
          if (state.bookedSlots.isEmpty) {
            return const Center(child: Text('No booked slots available.'));
          }

          return ListView.builder(
            itemCount: state.bookedSlots.length,
            itemBuilder: (context, index) {
              final slot = state.bookedSlots[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white, // Background color for the tile
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    leading: const Icon(Icons.local_parking,
                        color: Colors.green, size: 30),
                    title: Text(
                      'Slot ID: ${slot.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height: 4), // Adds space between title and subtitle
                        Text(
                          'Reserved on: ${_formatDate(slot.createdAt)}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          'Vehicle Plate: ${slot.plateNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon:
                          const Icon(Icons.cancel, color: Colors.red, size: 28),
                      onPressed: () => context
                          .read<UserCubit>()
                          .showExitDialog(context, slot.id),
                      //  showExitDialog(context, slot.id),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is ParkingError) {
          return Center(child: Text(state.errorMessage));
        } else {
          // return const Center(child: Text('No data to display.'));
          return ListView.builder(
            itemCount: 6, // Placeholder count for shimmer effect
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 100, // Height of the shimmer box
                ),
              ),
            ),
          );
        }
      },
    );
  }

  /// Helper function to format date
  String _formatDate(String? date) {
    if (date == null) return 'Unknown';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat.yMMMd().add_jm().format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  // /// Show Exit Confirmation Dialog
  // void _showExitDialog(BuildContext context, int slotId) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Exit Slot'),
  //         content: const Text('Are you sure you want to exit this slot?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //               // Trigger exit logic
  //               await context.read<ParkingCubit>().exitSlot(slotId);
  //             },
  //             child: const Text('Confirm'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}


//end exit slot