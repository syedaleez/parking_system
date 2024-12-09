import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/user_cubit.dart';
import '../../../states/user_state.dart';
// import '../cubit/user_cubit.dart';
// import '../states/user_state.dart'; // Import your user states

class UserProfileTab extends StatelessWidget {
  const UserProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('User Profile'),
    //     leading: IconButton(
    //         onPressed: () {
    //           context.read<AuthCubit>().logout();
    //           Navigator.pushReplacementNamed(context, '/login');
    //         },
    //         icon: Icon(Icons.logout_outlined)),
    //   ),
    //   body: BlocBuilder<UserCubit, UserState>(
    //     builder: (context, state) {
    //       if (state is UserLoading) {
    //         return Center(child: CircularProgressIndicator());
    //       } else if (state is UserDataLoaded) {
    //         final userData = state.userData;
    //         return Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text('Name: ${userData['fullName'] ?? 'N/A'}',
    //                 style: TextStyle(fontSize: 18)),
    //             Text('Email: ${userData['email'] ?? 'N/A'}',
    //                 style: TextStyle(fontSize: 18)),
    //             Text('Phone Number: ${userData['phoneNumber'] ?? 'N/A'}',
    //                 style: TextStyle(fontSize: 18)),
    //             Text('State: ${userData['state'] ?? 'N/A'}',
    //                 style: TextStyle(fontSize: 18)),
    //             // Text('Created At: ${userData['createdAt'].toDate().toString() ?? 'N/A'}', style: TextStyle(fontSize: 18)),
    //           ],
    //         );
    //       } else if (state is UserError) {
    //         return Center(
    //             child: Text(state.error, style: TextStyle(color: Colors.red)));
    //       } else {
    //         return Center(child: Text('No user data available'));
    //       }
    //     },
    //   ),

    // );

    //b box codeeeeeeeeeeeeee

    return Scaffold(
      appBar: AppBar(
        title: Text('User  Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () {
            context.read<AuthCubit>().logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
          icon: Icon(Icons.logout_outlined),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserDataLoaded) {
            final userData = state.userData;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // children: [
                    //   Text('User  Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    //   SizedBox(height: 20),
                    //   _buildUser InfoRow('Name:', userData['fullName'] ?? 'N/A'),
                    //   _buildUser InfoRow('Email:', userData['email'] ?? 'N/A'),
                    //   _buildUser InfoRow('Phone Number:', userData['phoneNumber'] ?? 'N/A'),
                    //   _buildUser InfoRow('State:', userData['state'] ?? 'N/A'),
                    //   // Uncomment if you want to display createdAt
                    //   // _buildUser InfoRow('Created At:', userData['createdAt']?.toDate().toString() ?? 'N/A'),
                    // ],

                    children: [
                      Text('Name: ${userData['fullName'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      Text('Email: ${userData['email'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      Text('Phone Number: ${userData['phoneNumber'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      Text('State: ${userData['state'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      // Text(
                      //     'Created At: ${userData['createdAt'].toDate().toString() ?? 'N/A'}',
                      //     style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is UserError) {
            return Center(
              child: Text(state.error,
                  style: TextStyle(color: Colors.red, fontSize: 18)),
            );
          } else {
            return Center(
                child: Text('No user data available',
                    style: TextStyle(fontSize: 18)));
          }
        },
      ),
    );
  }
}

//imdaad krny wala  function
Widget _buildProfileItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        //
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87, // Darker color for better readability
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400, // Regular weight for value
              color: Colors.blueGrey, // Slightly muted color for values
            ),
          ),
        ),
      ],
    ),
  );
}
