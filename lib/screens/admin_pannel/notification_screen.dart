import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('booked_slots').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //  CircularProgressIndicator();
            return ListView.builder(
              itemCount: 12, // Placeholder count for shimmer effect
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8), // Spacing around the shimmer
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 70, // Height of the shimmer box
                  ),
                ),
              ),
            );
          }
          final notifications = snapshot.data!.docs;
          // return ListView.builder(
          //   itemCount: notifications.length,
          //   itemBuilder: (context, index) {
          //     final notification = notifications[index];
          //     return ListTile(
          //       title: Text('Slot ID: ${notification['slotId']}'),
          //       subtitle: Text('Plate: ${notification['plateNumber']}'),
          //     );
          //   },
          // );

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    title: Text(
                      'Slot ID: ${notification['slotId']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Plate: ${notification['plateNumber']}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
