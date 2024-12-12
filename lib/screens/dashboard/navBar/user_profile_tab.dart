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
