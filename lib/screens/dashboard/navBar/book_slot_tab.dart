// booked_slots_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/parking_cubit.dart';
// import '../cubit/parking_cubit.dart';

class BookedSlotsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<ParkingCubit>().fetchBookedSlots(ParkingCubit());  // Trigger fetch

    return BlocBuilder<ParkingCubit, ParkingState>(
      builder: (context, state) {
        if (state is ParkingLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is BookedSlotsLoaded) {
          return ListView.builder(
            itemCount: state.bookedSlots.length,
            itemBuilder: (context, index) {
              final slot = state.bookedSlots[index];
              return ListTile(
                title: Text('Slot ID: ${slot.id}'),
                subtitle: Text('Reserved at: ${slot.updatedAt}'),
              );
            },
          );
        } else if (state is ParkingError) {
          return Center(child: Text(state.errorMessage));
        }
        return Center(child: Text('No booked slots available'));
      },
    );
  }
}
