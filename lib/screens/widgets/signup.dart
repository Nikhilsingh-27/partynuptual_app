import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_add, color: Colors.black),
      title: const Text(
        "Sign Up",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
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
            child: Text(
              'Vendor Sign Up',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const PopupMenuItem(
            value: 'guest',
            child: Text('Guest Sign Up', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
