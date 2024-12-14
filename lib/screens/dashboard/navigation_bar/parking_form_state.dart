import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/parking/parking_cubit.dart';
import '../../../logic/parking/parking_state.dart';

class ParkingForm extends StatelessWidget {
  final int slotId;
  final int vehicleSizeId;

  const ParkingForm(
      {super.key, required this.slotId, required this.vehicleSizeId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController plateNumberController = TextEditingController();

    return BlocListener<ParkingCubit, ParkingState>(
      listener: (context, state) {
        if (state is ParkingLoading) {
          // Optionally show a loading indicator
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Loading...')));
        } else if (state is ParkingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vehicle parked successfully')));
        } else if (state is ParkingError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: plateNumberController,
            decoration: const InputDecoration(
              labelText: 'Plate Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final plateNumber = plateNumberController.text;
              if (plateNumber.isNotEmpty) {
                // Trigger the API call via the cubit
                context
                    .read<ParkingCubit>()
                    .bookSlot(slotId, plateNumber, vehicleSizeId);
                Navigator.pop(context); // Close the form
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a plate number')));
              }
            },
            child: const Text('Park Vehicle'),
          ),
        ],
      ),
    );
  }
}
