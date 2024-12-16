import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/authenticate/auth_cubit.dart';

void showAdditionalDetailsForm(BuildContext context, String userId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final nameController = TextEditingController();
      final phoneController = TextEditingController();
      final stateController = TextEditingController();

      return AlertDialog(
        title: const Text('Complete Your Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(labelText: 'State'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text;
              final phone = phoneController.text;
              final state = stateController.text;

              if (name.isNotEmpty && phone.isNotEmpty && state.isNotEmpty) {
                await context.read<AuthCubit>().saveAdditionalDetails(userId, {
                  'name': name,
                  'phone': phone,
                  'state': state,
                });
                // ignore: use_build_context_synchronously
                Navigator.pop(context); // Close the dialog
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill out all fields')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
