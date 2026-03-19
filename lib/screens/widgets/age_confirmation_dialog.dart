import 'package:flutter/material.dart';

class AgeConfirmationDialog extends StatelessWidget {
  const AgeConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Age'),
      content: const Text(
        'Please confirm that you are 18 years of age or older to continue using the app.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
