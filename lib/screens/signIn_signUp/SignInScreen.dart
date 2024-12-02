///newwwwwwwwwwwww
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/cubit/register_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cubit/auth_cubit.dart';

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

  // void initState() {
  //   super.initState();
  //   // Generate captcha when screen loads
  //   context.read<AuthCubit>().regenerateCaptcha();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child:
            BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login Successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacementNamed(context, '/home');
              }
              
              else if(_emailController.text=='admin@gmail.com'){
                Navigator.pushReplacementNamed(context, '/admin_home');
              }
               else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
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
            // Captcha value from state
            String captcha = (state is AuthInitial) ? state.captcha : '------';
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _captchaController,
                      decoration: InputDecoration(
                        labelText: 'Enter Captcha: $captcha',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().regenerateCaptcha();
                      },
                      child: const Text('Refresh Captcha'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
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
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              final captchaInput = _captchaController.text;
                              context.read<AuthCubit>().login(
                                  email, password, captchaInput, _rememberMe);
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Sign In',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Center(child: Text("Don't have an account?")),
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ))),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
