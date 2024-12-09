// //new for parking slotttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart'; // For formatting dates
// import '../../../cubit/parking_cubit.dart';
// // import '../../../models/parkingSlot_model.dart';

// class BookedSlotsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     context
//         .read<ParkingCubit>()
//         .fetchBookedSlots(); // Trigger fetch from Firestore

//     return BlocBuilder<ParkingCubit, ParkingState>(
//       builder: (context, state) {
//         if (state is ParkingLoading) {
//           return Center(child: CircularProgressIndicator());
//         } else if (state is BookedSlotsLoaded) {
//           if (state.bookedSlots.isEmpty) {
//             return Center(child: Text('No booked slots available.'));
//           }

//           return ListView.builder(
//             itemCount: state.bookedSlots.length,
//             itemBuilder: (context, index) {
//               final slot = state.bookedSlots[index];
//               return ListTile(
//                 leading: Icon(Icons.local_parking, color: Colors.green),
//                 title: Text('Slot ID: ${slot.id}'),
//                 subtitle: Text(
//                   'Reserved on: ${_formatDate(slot.createdAt)}\n'
//                   'Vehicle Plate: ${slot.data.join(", ")}',
//                   // 'Vehicle Plate: ${slot.data?.join(", ") ?? "No Data"}',
//                 ),
//                 // isThreeLine: true,
//               );
//             },
//           );
//         } else if (state is ParkingError) {
//           return Center(child: Text(state.errorMessage));
//         }
//         return Center(child: Text('No data to display.'));
//       },
//     );

//   }

//   /// Helper function to format date
//   String _formatDate(String? date) {
//     if (date == null) return 'Unknown';
//     try {
//       final parsedDate = DateTime.parse(date);
//       return DateFormat.yMMMd().add_jm().format(parsedDate);
//     } catch (e) {
//       return 'Invalid Date';
//     }
//   }
// }

//for exit slot
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For formatting dates
import '../../../cubit/parking_cubit.dart';

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
                ),
                trailing: IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => _showExitDialog(context, slot.id),
                ),
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

  /// Show Exit Confirmation Dialog
  void _showExitDialog(BuildContext context, int slotId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit Slot'),
          content: Text('Are you sure you want to exit this slot?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Trigger exit logic
                await context.read<ParkingCubit>().exitSlot(slotId);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}


//end exit slot