import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_system/cubit/auth_cubit.dart';
import 'package:parking_system/screens/custom_widges/custom_snackbar.dart';
import 'package:parking_system/screens/custom_widges/custom_textfield.dart';
import '../../cubit/register_cubit.dart'; // Ensure correct path

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stateController = TextEditingController();
  bool _acceptedTerms = false;
  String? _selectedState;
  final List<String> states = [
    'Calafornia',
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
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text('Registration Successful!'),
              //   backgroundColor: Colors.green,
              // ));

              CustomSnackBar.show(
                context: context,
                message: 'Registration Successful!',
                backgroundColor: Colors.green,
                icon: Icons.check_circle,
              );

              Navigator.pushReplacementNamed(
                  context, '/home'); // Navigate to home
            } else if (state is AdminAuthenticated) {
              Navigator.pushReplacementNamed(context, '/admin_home');
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                // TextField(
                //   controller: _fullNameController,
                //   decoration: InputDecoration(labelText: 'Full Name'),
                // ),

                CustomTextField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                    icon: Icons.person),
                SizedBox(height: 10),

                CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email),
                SizedBox(height: 10),

                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.password,
                  obscureText: true,
                ),

                SizedBox(height: 10),

                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),

                // State
                // TextField(
                //   controller: _stateController,
                //   decoration: InputDecoration(labelText: 'State'),
                // ),

// DropdownMenu(dropdownMenuEntries: dropdownMenuEntries)
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
                      fillColor: const Color.fromARGB(255, 199, 185, 185),
                      prefixIcon:
                          Icon(Icons.location_city, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),

                        // hint: Text('Select a state'),
                      ),
                    )),

                SizedBox(height: 10),

                // Terms and Conditions Checkbox
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
                    Expanded(
                      child: Text('I accept the Terms and Conditions'),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Register Button
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return
                        // ElevatedButton(
                        //   onPressed: state is RegisterLoading ? null : () {
                        //     final fullName = _fullNameController.text.trim();
                        //     final email = _emailController.text.trim();
                        //     final password = _passwordController.text.trim();
                        //     final phoneNumber = _phoneController.text.trim();
                        //     final stateInput = _stateController.text.trim();

                        //     context.read<RegisterCubit>().register(
                        //       fullName,
                        //       email,
                        //       password,
                        //       phoneNumber,
                        //       stateInput,
                        //       _acceptedTerms,
                        //     );
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     minimumSize: Size(double.infinity, 50),
                        //     backgroundColor: Colors.blue,
                        //   ),
                        //   child: state is RegisterLoading
                        //       ? CircularProgressIndicator(color: Colors.white)
                        //       : Text(
                        //           'Register',
                        //           style: TextStyle(fontSize: 18, color: Colors.white),
                        //         ),
                        // );
                        //firebase Elevated button

                        ElevatedButton(
                      onPressed: () {
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
                              _acceptedTerms, // Checkbox value
                            );
                        print('user registered');
                      },
                      child: const Text('Register'),
                    );
                  },
                ),

                SizedBox(height: 10),

                // Sign In Link
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
    );
  }
}
