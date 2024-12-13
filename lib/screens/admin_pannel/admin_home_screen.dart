import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/navigation/route_name.dart';
import 'package:parking_system/screens/common_widges/custom_elevated_button.dart';
import 'package:parking_system/screens/common_widges/custom_snackbar.dart';
import 'package:parking_system/screens/dashboard/navBar/homeTab.dart';
import '../../cubit/admin_cubit.dart';
import '../../states/admin_state.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _nameController = TextEditingController();
  final _rankController = TextEditingController();
  final Map<String, int> _slotMap = {'1': 1, '2': 2, '3': 3}; //

  Map<String, int> slotsMap = {};
  final _slotKeyController = TextEditingController(); // For slot keys
  final _slotValueController = TextEditingController();
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _setupNotificationListener(); // **Setup Firestore Listener** (Highlighted change)
  }

  void _setupNotificationListener() {
    FirebaseFirestore.instance.collection('booked_slots').snapshots().listen(
      (snapshot) {
        if (snapshot.docChanges
            .any((change) => change.type == DocumentChangeType.added)) {
          setState(() {
            notificationCount += 1; // Increment count by 1
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rankController.dispose();
    _slotKeyController.dispose();
    _slotValueController.dispose();
    super.dispose();
  }

//new for validation in admin

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is ParkingLotCreated) {
          CustomSnackBar.show(
            context: context,
            message: 'Parking Lot Created',
          );
        }
        if (state is ParkingLotCreationFailure) {
          CustomSnackBar.show(
            context: context,
            backgroundColor: Colors.red,
            message: 'Failed to Create Parking Lot ',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, login);
            },
            icon: Icon(Icons.logout_sharp),
            color: Colors.white,
          ),
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, notification);
                    setState(() {
                      notificationCount = 0;
                    });
                  },
                  icon: const Icon(Icons.notifications),
                  color: Colors.white,
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$notificationCount',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Parking Lot',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Parking Lot Name Field
                  _buildTextField(
                    controller: _nameController,
                    label: 'Parking Lot Name',
                    icon: Icons.local_parking,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Parking lot name is required';
                      }
                      // if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
                      //   return 'Parking lot name must only contain letters';
                      // }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Rank Field
                  _buildTextField(
                    controller: _rankController,
                    label: 'Rank',
                    icon: Icons.abc,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final rank = int.tryParse(value ?? '');
                      if (rank == null || rank <= 0) {
                        return 'Rank must be a number greater than 0';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Define Slots Section
                  Text(
                    'Define Slots',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  Column(
                    children: [
                      SizedBox(
                        width: double
                            .infinity, // Makes the widget take full width of the parent
                        child: _buildDropdown(
                          hint: 'Slot Key (e.g., "1")',
                          items: List.generate(
                              10, (index) => (index + 1).toString()),
                          onSelected: (value) {
                            _slotKeyController.text = value ?? '';
                          },
                        ),
                      ),
                      SizedBox(height: 10), // Add spacing between the dropdowns
                      SizedBox(
                        width: double.infinity,
                        child: _buildDropdown(
                          hint: 'Spaces (e.g., "5")',
                          items: List.generate(
                              20, (index) => (index + 1).toString()),
                          onSelected: (value) {
                            _slotValueController.text = value ?? '';
                          },
                        ),
                      ),
                      SizedBox(height: 10), // Add spacing before the button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              'Add Slot',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                            onPressed: () {
                              final key = _slotKeyController.text.trim();
                              final value = int.tryParse(
                                      _slotValueController.text.trim()) ??
                                  0;
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
                    ],
                  ),

                  SizedBox(height: 10),

                  // Display Slots
                  if (slotsMap.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      children: slotsMap.entries.map((entry) {
                        return Chip(
                          label: Text('${entry.key}: ${entry.value}'),
                          deleteIcon: Icon(Icons.close, color: Colors.red),
                          onDeleted: () {
                            setState(() {
                              slotsMap.remove(entry.key);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 20),

                  Center(
                    child: CustomElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (slotsMap.length != 3) {
                            CustomSnackBar.show(
                              context: context,
                              backgroundColor: Colors.red,
                              message: 'Exactly 3 slots must be defined.',
                            );
                            return;
                          }
                          final name = _nameController.text;
                          final rank = int.parse(_rankController.text);

                          context
                              .read<AdminCubit>()
                              .createParkingLot(name, rank, slotsMap);

                          _nameController.clear();
                          _rankController.clear();
                          setState(() {
                            slotsMap.clear();
                          });
                        }
                      },
                      text: "Create Parking Lot",
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, viewUser);
                    },
                    text: "View User Details",
                  ),
                  const SizedBox(height: 10),

                  CustomElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, jhjhjhjhj);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomeTab()));
                    },
                    text: "View All Slots",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Updated TextField Helper
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onSelected,
  }) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      hint: Text(hint),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onSelected,
    );
  }
}
