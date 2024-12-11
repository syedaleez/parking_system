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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('User  Profile',
    //         style: TextStyle(fontWeight: FontWeight.bold)),
    //     leading: IconButton(
    //       onPressed: () {
    //         context.read<AuthCubit>().logout();
    //         Navigator.pushReplacementNamed(context, '/login');
    //       },
    //       icon: Icon(Icons.logout_outlined),
    //     ),
    //     backgroundColor: Colors.blueAccent,
    //   ),
    //   body: BlocBuilder<UserCubit, UserState>(
    //     builder: (context, state) {
    //       if (state is UserLoading) {
    //         return Center(child: CircularProgressIndicator());
    //       } else if (state is UserDataLoaded) {
    //         final userData = state.userData;
    //         return Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Card(
    //             elevation: 4,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(17),
    //             ),
    //             child: Padding(
    //               padding: const EdgeInsets.all(40.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,

    //                 children: [
    //                   Text('Name: ${userData['fullName'] ?? 'N/A'}',
    //                       style: TextStyle(fontSize: 18)),
    //                   Text('Email: ${userData['email'] ?? 'N/A'}',
    //                       style: TextStyle(fontSize: 18)),
    //                   Text('Phone Number: ${userData['phoneNumber'] ?? 'N/A'}',
    //                       style: TextStyle(fontSize: 18)),
    //                   Text('State: ${userData['state'] ?? 'N/A'}',
    //                       style: TextStyle(fontSize: 18)),

    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       } else if (state is UserError) {
    //         return Center(
    //           child: Text(state.error,
    //               style: TextStyle(color: Colors.red, fontSize: 18)),
    //         );
    //       } else {
    //         return Center(
    //             child: Text('No user data available',
    //                 style: TextStyle(fontSize: 18)));
    //       }
    //     },
    //   ),
    // );

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserDataLoaded) {
            final userData = state.userData;
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Profile Circle

                      Container(
                        width: screenWidth * 0.3, // 30% of screen width
                        height: screenWidth * 0.3, // Circular shape
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                        child: Center(
                          child: Text(
                            userData['fullName'] != null &&
                                    userData['fullName'].isNotEmpty
                                ? userData['fullName'][0]
                                    .toUpperCase() // First letter in uppercase
                                : '?', // Fallback if the name is unavailable
                            style: TextStyle(
                              fontSize: screenWidth *
                                  0.15, // Dynamically adjust font size
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03), // Spacing
                      // User Details
                      Text(
                        'Name: ${userData['fullName'] ?? 'N/A'}',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Email: ${userData['email'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 21),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Phone Number: ${userData['phoneNumber'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 21),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'State: ${userData['state'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 21),
                      ),
                    ],
                  ),
                ),

                // Logout Button
                Positioned(
                  top: MediaQuery.of(context).size.height *
                      0.01, // Adjusts top position based on screen height
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: IconButton(
                    icon: Icon(Icons.logout_outlined, color: Colors.blueAccent),
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ),
              ],
            );
          } else if (state is UserError) {
            return Center(
              child: Text(state.error,
                  style: TextStyle(color: Colors.red, fontSize: 18)),
            );
          } else {
            return Center(
              child: Text(
                'No user data available',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }
}

//imdaad krny wala  function
// Widget _buildProfileItem(String label, String value) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       children: [
//         //
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87, // Darker color for better readability
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             textAlign: TextAlign.end,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w400, // Regular weight for value
//               color: Colors.blueGrey, // Slightly muted color for values
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
