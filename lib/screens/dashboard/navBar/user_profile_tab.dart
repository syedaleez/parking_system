import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/user_cubit.dart';
import '../../../states/user_state.dart';
// import '../cubit/user_cubit.dart';
// import '../states/user_state.dart'; // Import your user states

class UserProfileTab extends StatelessWidget {
  const UserProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserDataLoaded) {
            final userData = state.userData;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${userData['fullName'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18)),
                Text('Email: ${userData['email'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18)),
                Text('Phone Number: ${userData['phoneNumber'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18)),
                Text('State: ${userData['state'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18)),
                // Text('Created At: ${userData['createdAt'].toDate().toString() ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              ],
            );
          } else if (state is UserError) {
            return Center(
                child: Text(state.error, style: TextStyle(color: Colors.red)));
          } else {
            return Center(child: Text('No user data available'));
          }
        },
      ),

      // body: BlocBuilder<UserCubit, UserState>(
      //   builder: (context, state) {
      //     if (state is UserLoading) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (state is UserDataLoaded) {
      //       final userData = state.userData;

      //       // Display user data in a structured format
      //       return Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             _buildProfileItem('Phone Number', userData['phoneNumber']),

      //             _buildProfileItem('Full Name', userData['fullName']),
      //             _buildProfileItem('State', userData['state']),

      //             _buildProfileItem('Email', userData['email']),
      //             // _buildProfileItem('Created At', userData['createdAt']),
      //           ],
      //         ),
      //       );
      //     } else if (state is UserError) {
      //       return Center(
      //         child: Text(
      //           state.error,
      //           style: TextStyle(color: Colors.red, fontSize: 18),
      //         ),
      //       );
      //     } else {
      //       return Center(
      //         child: Text('No user data available.'),
      //       );
      //     }
      //   },
      // ),
    );
  }

  // Helper method to build each profile item
  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
