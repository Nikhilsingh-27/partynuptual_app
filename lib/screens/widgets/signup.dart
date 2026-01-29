import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_add),
      title: const Text(
        "Sign Up",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.arrow_drop_down),
        onSelected: (value) {
          if (value == 'vendor') {
            Get.toNamed("/vsignup");
          } else if (value == 'guest') {
            Get.toNamed("/gsignup");
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'vendor',
            child: Text('Vendor Sign Up'),
          ),
          const PopupMenuItem(
            value: 'guest',
            child: Text('Guest Sign Up'),
          ),
        ],
      ),
    );
  }
}
