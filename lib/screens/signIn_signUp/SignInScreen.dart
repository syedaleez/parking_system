///newwwwwwwwwwwww
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/screens/custom_widges/custom_elevatedButton.dart';
import 'package:parking_system/screens/custom_widges/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/parking_cubit.dart';
import '../custom_widges/custom_snackbar.dart';
import 'google_signin_form.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
//new for additional details
            if (state is AuthAdditionalDetailsRequired) {
              showAdditionalDetailsForm(context, state.userId);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
//end hereeeeeeeeeeee

            if (state is AuthSuccess) {
              context.read<ParkingCubit>().fetchAndMonitorSlots();

              CustomSnackBar.show(
                context: context,
                message: 'Login Successful!',
                backgroundColor: Colors.green,
                icon: Icons.check_circle,
              );

              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AdminAuthenticated) {
              print('enter hogya inside AdminAuth');
            } else if (state is AuthFailure) {
              CustomSnackBar.show(
                context: context,
                message: 'Fill all fields correctly',
                backgroundColor: Colors.red,
                icon: Icons.cancel,
              );
            }
          },
//checkRole method wala

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

                      CustomTextField(
                        controller: _captchaController,
                        labelText: 'Enter Captcha: $captcha ',
                        icon: Icons.security,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 10),

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

                      CustomElevatedButton(
                        onPressed: () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          final captchaInput = _captchaController.text;

                          // Call the login function from your Cubit
                          context.read<AuthCubit>().login(context, email,
                              password, captchaInput, _rememberMe);
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
