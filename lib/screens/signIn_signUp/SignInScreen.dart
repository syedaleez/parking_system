///newwwwwwwwwwwww
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/screens/custom_widges/custom_elevatedButton.dart';
import 'package:parking_system/screens/custom_widges/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cubit/auth_cubit.dart';
import '../custom_widges/custom_snackbar.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // New method call
    context.read<AuthCubit>().regenerateCaptcha();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe =
          prefs.containsKey('email'); // Set checkbox based on saved data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text('Login Successful!'),
              //     backgroundColor: Colors.green,
              //   ),
              // );

              CustomSnackBar.show(
                context: context,
                message: 'Login Successful!',
                backgroundColor: Colors.green,
                icon: Icons.check_circle,
              );
              Navigator.pushReplacementNamed(context, '/home');
            } else if (_emailController.text == 'admin@gmail.com' &&
                _passwordController.text == '11223344') {
              Navigator.pushReplacementNamed(context, '/admin_home');
            } else if (state is AuthFailure) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Row(
              //       children: [
              //         Icon(
              //           Icons.error_outline, // Error icon for visual emphasis
              //           color: Colors.white,
              //         ),
              //         SizedBox(width: 10), // Space between icon and text
              //         Expanded(
              //           child: Text(
              //             state.errorMessage,
              //             style: TextStyle(
              //                 fontSize: 16), // Larger text for readability
              //           ),
              //         ),
              //       ],
              //     ),
              //     backgroundColor:
              //         Colors.red.shade700, // Deeper red for consistency
              //     behavior: SnackBarBehavior
              //         .floating, // Floating style for modern appearance
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(
              //           10), // Rounded corners for aesthetics
              //     ),
              //     duration: Duration(seconds: 4), // Display time
              //   ),
              // );

              CustomSnackBar.show(
                context: context,
                message: 'Fill all fields correctly',
                backgroundColor: Colors.red,
                icon: Icons.cancel,
              );
            }
          },
//checkRole method wala

          //   BlocConsumer<AuthCubit, AuthState>(
          // listener: (context, state) {
          //   if (state is AdminAuthenticated) {
          //     Navigator.pushReplacementNamed(context, '/admin_home');
          //   } else if (state is UserAuthenticated) {
          //     Navigator.pushReplacementNamed(context, '/home');
          //   } else if (state is AuthFailure) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         content: Text(state.errorMessage),
          //         backgroundColor: Colors.red,
          //       ),
          //     );
          //   }
          // },
          builder: (context, state) {
            bool isLoading = state is AuthLoading;

            // Captcha value from state
            String captcha = (state is AuthInitial) ? state.captcha : '------';
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with a modern font style and color
                      const Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 36, // Larger font size for visibility
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent, // Primary color
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email TextField
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon:
                              Icon(Icons.email, color: Colors.blueAccent),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                          ),
                          filled: true,
                          fillColor: Colors
                              .grey[200], // Soft background color for input
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password TextField
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon:
                              Icon(Icons.lock, color: Colors.blueAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Captcha TextField
                      // TextField(
                      //   controller: _captchaController,
                      //   decoration: InputDecoration(
                      //     labelText: 'Enter Captcha: $captcha',
                      //     prefixIcon:
                      //         Icon(Icons.security, color: Colors.blueAccent),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //     filled: true,
                      //     fillColor: Colors.grey[200],
                      //   ),
                      // ),

                      CustomTextField(
                        controller: _captchaController,
                        labelText: 'Enter Captcha: $captcha ',
                        icon: Icons.security,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 10),

                      // Refresh Captcha Button
                      // ElevatedButton(
                      //   onPressed: () {
                      //     context.read<AuthCubit>().regenerateCaptcha();
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.blueAccent,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(vertical: 12),
                      //   ),
                      //   child: Center(
                      //     child: Container(
                      //       padding: EdgeInsets.only(left: 4, right: 4),
                      //       child: Text('Refresh Captcha',
                      //           style: TextStyle(fontSize: 14)),
                      //     ),
                      //   ),
                      // ),

                      CustomElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().regenerateCaptcha();
                        },
                        text: 'Refresh Captcha',
                        fontSize: 14,
                        // textColor: const Color.fromARGB(255, 236, 228, 228),
                      ),

                      const SizedBox(height: 20),

                      // Remember Me and Forgot Password Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.blueAccent,
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              const Text('Remember Me'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Forgot password logic
                            },
                            child: const Text('Forgot Password?',
                                style: TextStyle(color: Colors.blueAccent)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Sign In Button
                      // ElevatedButton(
                      //   onPressed: state is AuthLoading
                      //       ? null
                      //       : () {
                      //           final email = _emailController.text;
                      //           final password = _passwordController.text;
                      //           final captchaInput = _captchaController.text;
                      //           context.read<AuthCubit>().login(
                      //               email, password, captchaInput, _rememberMe);
                      //         },
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: const Size(double.infinity, 50),
                      //     backgroundColor: Colors.blueAccent,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //   ),
                      //   child: state is AuthLoading
                      //       ? const CircularProgressIndicator(
                      //           color: Colors.white)
                      //       : const Text(
                      //           'Sign In',
                      //           style: TextStyle(
                      //               fontSize: 18, color: Colors.white),
                      //         ),
                      // ),

                      CustomElevatedButton(
                        onPressed: () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          final captchaInput = _captchaController.text;

                          // Call the login function from your Cubit
                          context.read<AuthCubit>().login(
                              email, password, captchaInput, _rememberMe);
                        },
                        text: 'Sign In',
                        isLoading:
                            isLoading, // Pass the loading state dynamically
                      ),

                      const SizedBox(height: 9),

                      // Register Option
                      const Center(child: Text("Don't have an account?")),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AuthCubit>().signInWithGoogle();
                        },
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text(
                          'Sign In with Google',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.redAccent, // Google brand color
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
