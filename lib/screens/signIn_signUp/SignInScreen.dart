// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../cubit/auth_cubit.dart';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final TextEditingController _captchaController = TextEditingController();
//   bool _rememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.0),
//         child: BlocListener<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is AuthSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                 content: Text('Login Successful!'),
//                 backgroundColor: Colors.green,
//               ));
//               Navigator.pushReplacementNamed(context, '/home');
//             } else if (state is AuthFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text(state.errorMessage),
//                 backgroundColor: Colors.red,
//               ));
//             }
//           },
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Sign In',
//                       style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SizedBox(height: 40),
//                   TextField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _rememberMe,
//                             onChanged: (value) {
//                               setState(() {
//                                 _rememberMe = value!;
//                               });
//                             },
//                           ),
//                           Text('Remember Me'),
//                         ],
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           // Forgot password logic
//                         },
//                         child: Text('Forgot Password?'),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
                  
//                   SizedBox(height: 20),
//                   BlocBuilder<AuthCubit, AuthState>(
//                     builder: (context, state) {
//                       return ElevatedButton(
//                         onPressed: state is AuthLoading ? null : () {
//                           final email = _emailController.text;
//                           final password = _passwordController.text;
//                           final captchaInput=_captchaController.text;
//                           context.read<AuthCubit>().login(email, password,captchaInput);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(double.infinity, 50),
//                           backgroundColor: Colors.blue,
//                         ),
//                         child: state is AuthLoading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text(
//                                 'Sign In',
//                                 style: TextStyle(fontSize: 18, color: Colors.white),
//                               ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }






////newwwwwwwwwwwww
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Generate captcha when screen loads
    context.read<AuthCubit>().regenerateCaptcha();
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login Successful!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            // Captcha value from state
            String captcha = (state is AuthInitial) ? state.captcha : '------';
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
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
                    SizedBox(height: 20),
                    TextField(
                      controller: _captchaController,
                      decoration: InputDecoration(
                        labelText: 'Enter Captcha: $captcha',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().regenerateCaptcha();
                      },
                      child: Text('Refresh Captcha'),
                    ),
                    SizedBox(height: 20),
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
                            Text('Remember Me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Forgot password logic
                          },
                          child: Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              final captchaInput = _captchaController.text;
                              context.read<AuthCubit>().login(
                                    email,
                                    password,
                                    captchaInput,
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                    ),
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


