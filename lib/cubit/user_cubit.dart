// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../repository/user_repo.dart';
// import '../states/user_state.dart';

// class UserCubit extends Cubit<UserState> {
//   final UserRepository userRepository;

//   UserCubit(this.userRepository) : super(UserInitial());

//   Future<void> fetchUserData() async {
//     emit(UserLoading());
//     try {
//       final data = await userRepository.getUserData();
//       emit(UserDataLoaded(data));
//     } catch (e) {
//       emit(UserError('Failed to load user data: ${e.toString()}'));
//     }
//   }
// }

//new vode
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/user_repo.dart';
import '../states/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  final userId = FirebaseAuth.instance.currentUser?.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//newwwwwwwst

  Future<void> fetchUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;

        // Convert Timestamp to DateTime if present
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
        }

        print('Fetched User Data: $data'); // Debug log
        emit(UserDataLoaded(data)); // Emit the correct state with user data
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      emit(UserError(
          'Failed to load profile: ${e.toString()}')); // Ensure error state is emitted
    }
  }
}
