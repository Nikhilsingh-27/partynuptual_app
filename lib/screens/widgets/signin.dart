import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.login, color: Colors.black),
      title: const Text(
        "Sign In",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        onSelected: (value) {
          if (value == 'vendor') {
            Get.toNamed("/vsignin");
          } else if (value == 'guest') {
            Get.toNamed("/gsignin");
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'vendor',
            child: Text(
              'Vendor Sign In',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const PopupMenuItem(
            value: 'guest',
            child: Text('Guest Sign In', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
