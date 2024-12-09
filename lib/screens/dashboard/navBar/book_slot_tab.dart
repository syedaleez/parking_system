// // booked_slots_tab.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../cubit/parking_cubit.dart';
// // import '../cubit/parking_cubit.dart';

// class BookedSlotsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     context.read<ParkingCubit>().fetchBookedSlots(ParkingCubit());  // Trigger fetch

//     return BlocBuilder<ParkingCubit, ParkingState>(
//       builder: (context, state) {
//         if (state is ParkingLoading) {
//           return Center(child: CircularProgressIndicator());
//         } else if (state is BookedSlotsLoaded) {
//           return ListView.builder(
//             itemCount: state.bookedSlots.length,
//             itemBuilder: (context, index) {
//               final slot = state.bookedSlots[index];
//               return ListTile(
//                 title: Text('Slot ID: ${slot.id}'),
//                 subtitle: Text('Reserved at: ${slot.updatedAt}'),
//               );
//             },
//           );
//         } else if (state is ParkingError) {
//           return Center(child: Text(state.errorMessage));
//         }
//         return Center(child: Text('No booked slots available'));
//       },
//     );
//   }
// }

//new for parking slotttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For formatting dates
import '../../../cubit/parking_cubit.dart';
// import '../../../models/parkingSlot_model.dart';

class BookedSlotsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context
        .read<ParkingCubit>()
        .fetchBookedSlots(); // Trigger fetch from Firestore

    return BlocBuilder<ParkingCubit, ParkingState>(
      builder: (context, state) {
        if (state is ParkingLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is BookedSlotsLoaded) {
          if (state.bookedSlots.isEmpty) {
            return Center(child: Text('No booked slots available.'));
          }

          return ListView.builder(
            itemCount: state.bookedSlots.length,
            itemBuilder: (context, index) {
              final slot = state.bookedSlots[index];
              return ListTile(
                leading: Icon(Icons.local_parking, color: Colors.green),
                title: Text('Slot ID: ${slot.id}'),
                subtitle: Text(
                  'Reserved on: ${_formatDate(slot.createdAt)}\n'
                  'Vehicle Plate: ${slot.data.join(", ")}',
                  // 'Vehicle Plate: ${slot.data?.join(", ") ?? "No Data"}',
                ),
                // isThreeLine: true,
              );
            },
          );
        } else if (state is ParkingError) {
          return Center(child: Text(state.errorMessage));
        }
        return Center(child: Text('No data to display.'));
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
}
