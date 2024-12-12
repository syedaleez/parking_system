import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../cubit/auth_cubit.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //check role for admin aur userr

  Future<String> checkRole(String email) async {
    // Fetch user data based on their email
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      if (email == 'admin@gmail.com') {
        return 'admin';
      }
      return userData['role'] ?? 'user';
    } else {
      throw Exception('User not found');
    }
  }

//function for google sign innn

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception("Google sign-in was canceled by the user");
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      throw Exception('Failed to sign in: ${e}');
    }
  }

  //check user detail exist in firestore while registerrrr

  Future<bool> checkUserExists(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.exists;
  }

  Future<void> saveUserDetails(
      String userId, Map<String, dynamic> userDetails) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userDetails);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  //register ka functionnn

//register function with firebaseee

  Future<void> register(String fullName, String email, String password,
      String phoneNumber, String state) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'state': state,
      'createdAt': DateTime.now(),
    });
  }
}

// //new with firebase
