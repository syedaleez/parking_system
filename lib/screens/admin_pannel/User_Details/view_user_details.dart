import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../cubit/parking_cubit.dart';

class ViewUserDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<ParkingCubit>().fetchAllBookedSlots();

    return Scaffold(
      appBar: AppBar(title: Text('All Booked Slots')),
      body: BlocBuilder<ParkingCubit, ParkingState>(
        builder: (context, state) {
          if (state is ParkingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AdminBookedSlotsLoaded) {
            final bookedSlots = state.bookedSlots;

            if (bookedSlots.isEmpty) {
              return Center(child: Text('No booked slots available.'));
            }

            return ListView.builder(
              itemCount: bookedSlots.length,
              itemBuilder: (context, index) {
                final slot = bookedSlots[index];
                return ListTile(
                  leading: Icon(Icons.local_parking, color: Colors.green),
                  title: Text('Slot ID: ${slot['slotId']}'),
                  // subtitle: Text(
                  //   'User: ${slot['userName']}\n'
                  //   'Plate: ${slot['plateNumber']}\n'
                  //   'Email: ${slot['userEmail']}\n'
                  //   'Booked At: ${DateFormat.yMMMd().add_jm().format(slot['timestamp'])}',
                  // ),

                  subtitle: RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black),
                      children: [
                        TextSpan(text: 'User: ${slot['userName']}\n'),
                        TextSpan(
                            text: 'Plate: ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(
                          text: '${slot['plateNumber']}\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'Email: ${slot['userEmail']}\n'),
                        TextSpan(
                          text:
                              'Booked At: ${DateFormat.yMMMd().add_jm().format(slot['timestamp'])}',
                        ),
                      ],
                    ),
                  ),
                  isThreeLine: true,
                );
              },
            );
          } else if (state is ParkingError) {
            return Center(child: Text(state.errorMessage));
          }

          return Center(child: Text('No data to display.'));
        },
      ),
    );
  }
}
