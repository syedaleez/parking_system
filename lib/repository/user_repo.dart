import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUserData() async {
    final querySnapshot = await _firestore.collection('parkingLots').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
