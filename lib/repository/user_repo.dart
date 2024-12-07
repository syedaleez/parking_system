import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final user = _auth.currentUser; // Get the current authenticated user
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        print(doc.data());
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception('User profile not found in Firestore');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: ${e.toString()}');
    }
  }
}
