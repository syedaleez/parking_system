//new with designnnnnnnnnn

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/cubit/parking_cubit.dart';
import 'package:parking_system/screens/custom_widges/custom_snackbar.dart';
import 'package:parking_system/screens/custom_widges/custom_textfield.dart';
import '../../models/parkingSlot_model.dart'; // Assuming you have a ParkingSlot model
import 'navBar/book_slot_tab.dart';
import 'navBar/homeTab.dart';
import 'navBar/user_profile_tab.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _selectedIndex = 0;
  TextEditingController _plateNumberController = TextEditingController();
  ParkingSlot? selectedSlot;
  bool isSlotSelected = false;

  final List<Widget> _screens = [
    HomeTab(),
    BookedSlotsTab(),
    UserProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to post vehicle data
  Future<void> bookParkingSlot(ParkingSlot slot) async {
    final plateNumber = _plateNumberController.text.trim();
    if (plateNumber.isEmpty) {
      CustomSnackBar.show(
        context: context,
        message: 'Please enter vehicle number',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    final Map<String, dynamic> bookingData = {
      'vehicleSizeId':
          1, // You can adjust this based on the slot size or another value
      'plateNumber': plateNumber,
      'parkingLotId': slot.parkingLotId,
    };

    try {
      final response = await http.post(
        Uri.parse('http"//192.168.10.23:5005/vehicle/park'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(bookingData),
      );

      if (response.statusCode == 200) {
        CustomSnackBar.show(
          context: context,
          message: 'Slot booked successfully!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
        // Optionally: You can update the list of booked slots or navigate elsewhere
      } else {
        CustomSnackBar.show(
          context: context,
          message: 'Failed to book slot',
          backgroundColor: Colors.red,
          icon: Icons.cancel,
        );
      }
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Error: $e',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parking App")),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: 'Booked Slots'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedSlot != null) {
            setState(() {
              isSlotSelected = true;
            });
            // showModalBottomSheet(
            //   context: context,
            //   builder: (context) {
            //     return Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Column(
            //         children: [
            //           Text(
            //             'Enter Vehicle Number for Slot ${selectedSlot?.id}',
            //             style: TextStyle(
            //                 fontSize: 18, fontWeight: FontWeight.bold),
            //           ),
            //           SizedBox(height: 20),
            //           CustomTextField(
            //             controller: _plateNumberController,
            //             labelText: 'Vehicle Plate Number',
            //             icon: Icons.car_repair,
            //           ),
            //           SizedBox(height: 20),
            //           ElevatedButton(
            //             onPressed: () {
            //               if (_plateNumberController.text.isNotEmpty) {
            //                 bookParkingSlot(selectedSlot!);
            //               } else {
            //                 CustomSnackBar.show(
            //                   context: context,
            //                   message: 'Plate number is required!',
            //                   backgroundColor: Colors.red,
            //                   icon: Icons.error,
            //                 );
            //               }
            //             },
            //             child: Text('Book Slot'),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // );

            ///newwwwwwwwwwwwwwwwwwwwwww
            void showBookingDialog(BuildContext context,
                ParkingCubit parkingCubit, ParkingSlot slot) {
              TextEditingController plateNumberController =
                  TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Book Slot ${slot.id}'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Enter your vehicle plate number'),
                        TextField(
                          controller: plateNumberController,
                          decoration: InputDecoration(
                            labelText: 'Plate Number',
                            icon: Icon(Icons.car_repair),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final plateNumber = plateNumberController.text.trim();
                          if (plateNumber.isNotEmpty) {
                            parkingCubit.postVehicleData(
                                slot.id, plateNumber, 1);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please enter a valid plate number.')),
                            );
                          }
                        },
                        child: Text('Book Slot'),
                      ),
                    ],
                  );
                },
              );
            }

            ///
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
