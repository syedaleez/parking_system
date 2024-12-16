import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../logic/parking/parking_cubit.dart';
import '../../logic/parking/parking_state.dart';

class ViewUserDetails extends StatelessWidget {
  const ViewUserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ParkingCubit>().fetchAllBookedSlots();

    return Scaffold(
      appBar: AppBar(title: const Text('All Booked Slots')),
      body: BlocBuilder<ParkingCubit, ParkingState>(builder: (context, state) {
        if (state is ParkingLoading) {
          // return Center(child: CircularProgressIndicator());
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
        } else if (state is AdminBookedSlotsLoaded) {
          final bookedSlots = state.bookedSlots;

          if (bookedSlots.isEmpty) {
            return const Center(child: Text('No booked slots available.'));
          }

          return ListView.builder(
            itemCount: bookedSlots.length,
            itemBuilder: (context, index) {
              final slot = bookedSlots[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // Spacing around the ListTile
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blueAccent,
                        width: 1.8), // Border color and thickness
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.local_parking,
                        color: Colors.green, size: 28),
                    title: Text(
                      'Slot ID: ${slot['slotId']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height: 8), // Space between title and subtitle
                        Text(
                          'User: ${slot['userName']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Plate: ${slot['plateNumber']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Email: ${slot['userEmail']}'),
                        Text(
                          'Booked At: ${DateFormat.yMMMd().add_jm().format(slot['timestamp'])}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              );
            },
          );
        } else if (state is ParkingError) {
          return Center(child: Text(state.errorMessage));
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
