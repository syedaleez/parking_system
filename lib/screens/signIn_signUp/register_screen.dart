// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:parking_system/cubit/auth_cubit.dart';
// import 'package:parking_system/screens/custom_widges/custom_elevatedButton.dart';
// import 'package:parking_system/screens/custom_widges/custom_snackbar.dart';
// import 'package:parking_system/screens/custom_widges/custom_textfield.dart';
// import '../../cubit/register_cubit.dart'; // Ensure correct path

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _stateController = TextEditingController();
//   bool _acceptedTerms = false;
//   String? _selectedState;
//   final List<String> states = [
//     'Calafornia',
//     'Texas',
//     'New York',
//     'Florida',
//     'Arizona',
//     'Ohio',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Register')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: BlocListener<RegisterCubit, RegisterState>(
//           listener: (context, state) {
//             if (state is RegisterSuccess) {
//               CustomSnackBar.show(
//                 context: context,
//                 message: 'Registration Successful!',
//                 backgroundColor: Colors.green,
//                 icon: Icons.check_circle,
//               );

//               Navigator.pushReplacementNamed(
//                   context, '/home'); // Navigate to home
//             } else if (state is AdminAuthenticated) {
//               Navigator.pushReplacementNamed(context, '/admin_home');
//             } else if (state is RegisterFailure) {
//               CustomSnackBar.show(
//                 context: context,
//                 message: 'Registration Failed!',
//                 backgroundColor: Colors.red,
//                 icon: Icons.cancel,
//               );
//             }
//           },
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Full Name
//                 // TextField(
//                 //   controller: _fullNameController,
//                 //   decoration: InputDecoration(labelText: 'Full Name'),
//                 // ),

//                 CustomTextField(
//                     controller: _fullNameController,
//                     labelText: 'Full Name',
//                     icon: Icons.person),
//                 SizedBox(height: 10),

//                 CustomTextField(
//                     controller: _emailController,
//                     labelText: 'Email',
//                     icon: Icons.email),
//                 SizedBox(height: 10),

//                 CustomTextField(
//                   controller: _passwordController,
//                   labelText: 'Password',
//                   icon: Icons.password,
//                   obscureText: true,
//                 ),

//                 const SizedBox(height: 10),

//                 CustomTextField(
//                   controller: _phoneController,
//                   labelText: 'Phone Number',
//                   icon: Icons.phone,
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 10),

//                 DropdownButtonFormField<String>(
//                     value: _selectedState,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedState = value;
//                       });
//                     },
//                     items: states.map((state) {
//                       return DropdownMenuItem<String>(
//                         value: state,
//                         child: Text(state),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(
//                       labelText: 'State',
//                       fillColor: const Color.fromARGB(255, 199, 185, 185),
//                       prefixIcon:
//                           Icon(Icons.location_city, color: Colors.blueAccent),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),

//                         // hint: Text('Select a state'),
//                       ),
//                     )),

//                 const SizedBox(height: 10),

//                 // Terms and Conditions Checkbox
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: _acceptedTerms,
//                       onChanged: (value) {
//                         setState(() {
//                           _acceptedTerms = value!;
//                         });
//                       },
//                     ),
//                     const Expanded(
//                       child: Text('I accept the Terms and Conditions'),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 // Register Button
//                 BlocBuilder<RegisterCubit, RegisterState>(
//                   builder: (context, state) {
//                     bool isLoading = state is RegisterLoading;
//                     return CustomElevatedButton(
//                       onPressed: () {
//                         final fullName = _fullNameController.text.trim();
//                         final email = _emailController.text.trim();
//                         final password = _passwordController.text.trim();
//                         final phoneNumber = _phoneController.text.trim();
//                         final state = _selectedState.toString();

//                         context.read<RegisterCubit>().register(
//                               fullName,
//                               email,
//                               password,
//                               phoneNumber,
//                               state,
//                               _acceptedTerms, // Checkbox value
//                             );
//                         print('user registered..........');
//                       },
//                       text: "Register",
//                       isLoading: isLoading,
//                     );
//                   },
//                 ),

//                 const SizedBox(height: 10),

//                 // Sign In Link
//                 Center(
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                     child: Text('Already have an account? Sign In'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//new with form validation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/cubit/auth_cubit.dart';
import 'package:parking_system/screens/custom_widges/custom_elevatedButton.dart';
import 'package:parking_system/screens/custom_widges/custom_snackbar.dart';
import 'package:parking_system/screens/custom_widges/custom_textfield.dart';
import '../../cubit/register_cubit.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>(); // Added for validation
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _acceptedTerms = false;
  String? _selectedState;
  final List<String> states = [
    'California',
    'Texas',
    'New York',
    'Florida',
    'Arizona',
    'Ohio',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              CustomSnackBar.show(
                context: context,
                message: 'Registration Successful!',
                backgroundColor: Colors.green,
                icon: Icons.check_circle,
              );
            } else if (state is RegisterFailure) {
              CustomSnackBar.show(
                context: context,
                message: 'Registration Failed!',
                backgroundColor: Colors.red,
                icon: Icons.cancel,
              );
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Added form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      if (RegExp(r'\d').hasMatch(value)) {
                        return 'Full name should not contain numbers';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Email format validation
                      if (!emailRegex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.password,
                    obscureText: true,
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
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      final phoneRegex = RegExp(
                          r'^[0-9]{10,15}$'); // Phone number format validation
                      if (!phoneRegex.hasMatch(value)) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    onChanged: (value) {
                      setState(() {
                        _selectedState = value;
                      });
                    },
                    items: states.map((state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'State',
                      prefixIcon:
                          Icon(Icons.location_city, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a state';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'I accept the Terms and Conditions',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  if (!_acceptedTerms)
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'You must accept the Terms and Conditions',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  SizedBox(height: 20),
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      bool isLoading = state is RegisterLoading;
                      return CustomElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _acceptedTerms) {
                            final fullName = _fullNameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final phoneNumber = _phoneController.text.trim();
                            final state = _selectedState.toString();

                            context.read<RegisterCubit>().register(
                                  fullName,
                                  email,
                                  password,
                                  phoneNumber,
                                  state,
                                  _acceptedTerms,
                                );
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        text: "Register",
                        isLoading: isLoading,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Already have an account? Sign In'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
