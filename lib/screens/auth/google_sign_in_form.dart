import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth_cubit.dart';

void showAdditionalDetailsForm(BuildContext context, String userId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final _nameController = TextEditingController();
      final _phoneController = TextEditingController();
      final _stateController = TextEditingController();

      return AlertDialog(
        title: Text('Complete Your Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text;
              final phone = _phoneController.text;
              final state = _stateController.text;

              if (name.isNotEmpty && phone.isNotEmpty && state.isNotEmpty) {
                await context.read<AuthCubit>().saveAdditionalDetails(userId, {
                  'name': name,
                  'phone': phone,
                  'state': state,
                });
                Navigator.pop(context); // Close the dialog
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill out all fields')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
