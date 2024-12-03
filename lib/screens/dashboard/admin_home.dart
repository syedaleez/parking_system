import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/screens/custom_widges/custom_snackbar.dart';
import 'package:parking_system/screens/custom_widges/custom_textfield.dart';
import '../../cubit/admin_cubit.dart';
import '../../states/admin_state.dart';
// import '../cubit/admin_cubit.dart';
// import '../states/admin_state.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _nameController = TextEditingController();
  final _rankController = TextEditingController();
  final Map<String, int> _slotMap = {'1': 1, '2': 2, '3': 3}; //
  // final _nameController = TextEditingController();
  // final _rankController = TextEditingController();
  // final _capacityController = TextEditingController();
  Map<String, int> slotsMap = {};
  final _slotKeyController = TextEditingController(); // For slot keys
  final _slotValueController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _rankController.dispose();
    _slotKeyController.dispose();
    _slotValueController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: BlocListener<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state is ParkingLotCreated) {
            print('Parking lot createdddddddddddddddddddddd$state');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Parking lot created successfully!'),
                  backgroundColor: Colors.green),
            );
          } else if (state is ParkingLotCreationFailure) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            // );
            CustomSnackBar.show(
              context: context,
              message: state.error,
              backgroundColor: Colors.red,
              icon: Icons.cancel,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField(
              //     controller: _nameController,
              //     decoration: InputDecoration(labelText: 'Parking Lot Name')),
              CustomTextField(
                  controller: _nameController,
                  labelText: 'Parking Lot Name',
                  icon: Icons.local_parking_sharp),
              // TextField(
              //   controller: _rankController,
              //   decoration: InputDecoration(labelText: 'Rank'),
              //   keyboardType: TextInputType.number,
              // ),
              CustomTextField(
                  controller: _rankController,
                  labelText: 'Rank',
                  icon: Icons.location_history_outlined),

              // TextField(
              //     controller: _capacityController,
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(labelText: 'Capacity')),

              const SizedBox(height: 20),
              const Text(
                'Define Slots',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _slotKeyController,
                      decoration:
                          InputDecoration(labelText: 'Slot Key (e.g., "1")'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _slotValueController,
                      decoration:
                          InputDecoration(labelText: 'Spaces (e.g., "5")'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      final key = _slotKeyController.text.trim();
                      final value =
                          int.tryParse(_slotValueController.text.trim()) ?? 0;
                      if (key.isNotEmpty && value > 0) {
                        setState(() {
                          slotsMap[key] = value;
                        });
                        _slotKeyController.clear();
                        _slotValueController.clear();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Display slots dynamically
              if (slotsMap.isNotEmpty)
                Wrap(
                  spacing: 10,
                  children: slotsMap.entries.map((entry) {
                    return Chip(
                      label: Text('${entry.key}: ${entry.value}'),
                      onDeleted: () {
                        setState(() {
                          slotsMap.remove(entry.key);
                        });
                      },
                    );
                  }).toList(),
                ),
              // SizedBox(height: 20),

              SizedBox(height: 20),
              // Fields: _nameController, _rankController, slotsMap (created dynamically)

              ElevatedButton(
                onPressed: () {
                  final name = _nameController.text;
                  final rank = int.tryParse(_rankController.text) ?? 0;

                  context
                      .read<AdminCubit>()
                      .createParkingLot(name, rank, _slotMap);
                },
                child: Text('Create Parking Lot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
