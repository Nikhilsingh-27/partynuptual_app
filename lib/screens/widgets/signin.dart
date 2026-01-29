import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.login),
      title: const Text(
        "Sign In",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.arrow_drop_down),
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
            child: Text('Vendor Sign In'),
          ),
          const PopupMenuItem(
            value: 'guest',
            child: Text('Guest Sign In'),
          ),
        ],
      ),
    );
  }
}
