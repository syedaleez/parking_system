import 'package:firebase_auth/firebase_auth.dart';

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

  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
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
  
   Future<void> register(String fullName, String email, String password, String phoneNumber, String state) async {
    try {
      // Simulated API call or backend logic
      // Replace this with your actual backend/Firebase call
      await Future.delayed(Duration(seconds: 2));  // Simulate network delay

      // Optionally, you could add logic here to check if the email is already registered.
      print('User registered: $fullName, $email, $phoneNumber, $state');
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }
}






// //new with firebase


