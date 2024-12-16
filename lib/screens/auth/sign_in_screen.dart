import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/routes/route_name.dart';
import 'package:parking_system/screens/common_widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../logic/authenticate/auth_cubit.dart';
import '../../logic/parking/parking_cubit.dart';
import '../common_widgets/custom_snackbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>(); // Added for form validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  bool _rememberMe = false;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    context.read<AuthCubit>().regenerateCaptcha();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.containsKey('email');
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              CustomSnackBar.show(
                context: context,
                message: 'Login Successful!',
                backgroundColor: Colors.green,
                icon: Icons.check_circle,
              );
              context.read<ParkingCubit>().fetchAndMonitorSlots();

              Navigator.pushReplacementNamed(context, home);
            } else if (state is AuthFailure) {
              CustomSnackBar.show(
                context: context,
                message: state.errorMessage,
                backgroundColor: Colors.red,
                icon: Icons.cancel,
              );
            }
          },
          builder: (context, state) {
            bool isLoading = state is AuthLoading;
            String captcha = (state is AuthInitial) ? state.captcha : '------';

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Form(
                    key: _formKey, // Added form key
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email,
                                color: Colors.blueAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock,
                                color: Colors.blueAccent),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: togglePasswordVisibility,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _captchaController,
                          decoration: InputDecoration(
                            labelText: 'Enter Captcha: $captcha',
                            prefixIcon: const Icon(Icons.security,
                                color: Colors.blueAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != _captchaController.text) {
                              return 'Invalid Captcha';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomElevatedButton(
                          onPressed: () {
                            context.read<AuthCubit>().regenerateCaptcha();
                            setState(() {
                              _captchaController.clear();
                            });
                          },
                          text: 'Refresh Captcha',
                          fontSize: 14,
                        ),
                        const SizedBox(height: 20),
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
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              final captchaInput = _captchaController.text;

                              context.read<AuthCubit>().login(
                                    context,
                                    email,
                                    password,
                                    captchaInput,
                                    _rememberMe,
                                  );
                            }
                          },
                          text: 'Sign In',
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 9),
                        const Center(child: Text("Don't have an account?")),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, register);
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
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
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
