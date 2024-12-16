import 'package:flutter/material.dart';
import '../../models/parking_slot_model.dart'; //
import 'navigation_bar/book_slot_tab.dart';
import 'navigation_bar/home_tab.dart';
import 'navigation_bar/user_profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  TextEditingController plateNumberController = TextEditingController();
  ParkingSlot? selectedSlot;
  bool isSlotSelected = false;

  final List<Widget> _screens = [
    const HomeTab(),
    const BookedSlotsTab(),
    const UserProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parking App")),
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
        selectedItemColor: Colors.blueAccent, // Icon color for selected item
        unselectedItemColor: Colors.grey, // Icon color for unselected items
        backgroundColor: Colors.white,
      ),
    );
  }
}
