





//navbar code
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'navBar/book_slot_tab.dart';
import 'navBar/homeTab.dart';
import 'navBar/user_profile_tab.dart';


class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _selectedIndex = 0;

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
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Booked Slots'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
