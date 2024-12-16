import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/routes/route_name.dart';
import '../../../logic/authenticate/auth_cubit.dart';
import '../../../logic/user/user_cubit.dart';
import '../../../logic/user/user_state.dart';
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserDataLoaded) {
            final userData = state.userData;
            return Stack(
              children: [
                // Default Background
                Container(
                  color: Colors.grey[100], // Subtle default background color
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Spacing from top
                      SizedBox(height: screenHeight * 0.1),

                      // Profile Circle
                      Container(
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.blueAccent, Colors.lightBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            userData['fullName'] != null &&
                                    userData['fullName'].isNotEmpty
                                ? userData['fullName'][0]
                                    .toUpperCase() // First letter
                                : '?',
                            style: TextStyle(
                              fontSize: screenWidth * 0.15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // User Details Section
                      Container(
                        height: 300,
                        width: screenWidth * 0.9, // 90% of screen width
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        margin: EdgeInsets.only(top: screenHeight * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    color: Colors.blueAccent),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Name: ${userData['fullName'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.email_outlined,
                                    color: Colors.blueAccent),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Email: ${userData['email'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined,
                                    color: Colors.blueAccent),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Phone Number: ${userData['phoneNumber'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    color: Colors.blueAccent),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'State: ${userData['state'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Logout Button
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      context.read<AuthCubit>().logout();
                      Navigator.pushReplacementNamed(context, login);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            );

            //new design work end
          } else if (state is UserError) {
            return Center(
              child: Text(state.error,
                  style: const TextStyle(color: Colors.red, fontSize: 18)),
            );
          } else {
            return const Center(
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
