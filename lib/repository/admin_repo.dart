import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createParkingLot(String name, String location, int capacity) async {
    await _firestore.collection('parkingLots').add({
      'name': name,
      'location': location,
      'capacity': capacity,
      'spaces': []
    });
  }

  Future<void> defineParkingSpaces(String lotId, List<String> spaces) async {
    await _firestore.collection('parkingLots').doc(lotId).update({
      'spaces': spaces
    });
  }
}
