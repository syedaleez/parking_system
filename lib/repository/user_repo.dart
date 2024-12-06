import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<List<Map<String, dynamic>>> getUserData() async {
  //   final querySnapshot = await _firestore.collection('parkingLots').get();
  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // Future<Map<String, dynamic>> getUserProfile(String userId) async {
  //   try {
  //     final DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();

  //     if (doc.exists) {
  //       return doc.data() as Map<String, dynamic>;  // Return the user profile data
  //     } else {
  //       throw Exception('User not found');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching user profile: ${e.toString()}');
  //   }
  // }

// Future<Map<String, dynamic>> getUserProfile() async {
//   try {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       return {
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': user.displayName ?? 'No Name',
//         'photoURL': user.photoURL ?? 'No Photo',
//       };
//     } else {
//       throw Exception('No authenticated user found.');
//     }
//   } catch (e) {
//     throw Exception('Error fetching user profile: ${e.toString()}');
//   }
// }

// Future<Map<String, dynamic>> getUserProfile() async {
//   try {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception('No authenticated user found.');

//     // Fetch additional data from Firestore
//     DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

//     if (doc.exists) {
//       // Merge Authentication data with Firestore data
//       Map<String, dynamic> profileData = doc.data() as Map<String, dynamic>;
//       return {
//         'uid': user.uid,
//         'email': user.email,
//         'fullName': user.displayName ?? profileData['name'],
//         'photoURL': user.photoURL ?? profileData['photoURL'],
//         ...profileData, // Merge Firestore data
//       };
//     } else {
//       throw Exception('User profile not found in Firestore.');
//     }
//   } catch (e) {
//     throw Exception('Error fetching user profile: ${e.toString()}');
//   }
// }

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Future<Map<String, dynamic>> getUserProfile() async {
//   try {
//     // Get the current user from Firebase Authentication
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception('No authenticated user found.');

//     // Fetch the user document from Firestore
//     DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

//     if (doc.exists) {
//       Map<String, dynamic> profileData = doc.data() as Map<String, dynamic>;

//       // Merge Firestore data with basic Auth data if needed
//       return {
//         'uid': user.uid,
//         'email': user.email ?? profileData['email'],  // Fallback to Firestore data
//         'fullName': profileData['fullName'],          // From Firestore
//         'phoneNumber': profileData['phoneNumber'],    // From Firestore
//         'state': profileData['state'],                // From Firestore
//         'createdAt': profileData['createdAt'],        // Firestore timestamp
//       };

//     } else {
//       throw Exception('User profile not found in Firestore.');
//     }
//   } catch (e) {
//     throw Exception('Error fetching user profile: ${e.toString()}');
//   }
// }

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

// //   Future<Map<String, dynamic>> getUserProfile(String userId) async {
//   final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
//   if (response.statusCode == 200) {
//     return json.decode(response.body);  // Ensure this is a Map
//   } else {
//     throw Exception('User not found');
//   }
// }
}
