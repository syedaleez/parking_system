import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/parking_cubit.dart';

class ParkingForm extends StatelessWidget {
  final int slotId;
  final int vehicleSizeId;

  ParkingForm({required this.slotId, required this.vehicleSizeId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _plateNumberController =
        TextEditingController();

    return BlocListener<ParkingCubit, ParkingState>(
      listener: (context, state) {
        if (state is ParkingLoading) {
          // Optionally show a loading indicator
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Loading...')));
        } else if (state is ParkingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Vehicle parked successfully')));
        } else if (state is ParkingError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _plateNumberController,
            decoration: InputDecoration(
              labelText: 'Plate Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final plateNumber = _plateNumberController.text;
              if (plateNumber.isNotEmpty) {
                // Trigger the API call via the cubit
                context
                    .read<ParkingCubit>()
                    .postVehicleData(slotId, plateNumber, vehicleSizeId);
                Navigator.pop(context); // Close the form
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a plate number')));
              }
            },
            child: Text('Park Vehicle'),
          ),
        ],
      ),
    );
  }
}
