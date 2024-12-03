import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../cubit/auth_cubit.dart';

class AuthRepository {
  // Future<bool> login(String email, String password) async {
  //   // API mili to call hogi
  //   await Future.delayed(const Duration(seconds: 3));

  //   if (email == 'abc@gmail.com' && password == 'password') {
  //     return true;
  //   }
  //   return false;
  // }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // FirebaseAuth.instance.setLanguageCode("en");  // Set the desired locale


  //check role for admin aur userr

  Future<String> checkRole(String email) async {
    // Fetch user data based on their email
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: 'admin@gmail.com')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      return userData['role'] ??
          'user'; // Default to 'user' if role is not specified
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

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
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

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  //register ka functionnnnnnnnnnnnnnnn

  //  Future<void> register(String fullName, String email, String password, String phoneNumber, String state) async {
  //   try {
  //     // Simulated API call or backend logic
  //     // Replace this with your actual backend/Firebase call
  //     await Future.delayed(Duration(seconds: 2));  // Simulate network delay

  //     // Optionally, you could add logic here to check if the email is already registered.
  //     print('User registered: $fullName, $email, $phoneNumber, $state');
  //   } catch (e) {
  //     throw Exception('Registration failed: ${e.toString()}');
  //   }
  // }

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
