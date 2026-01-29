import 'package:flutter/material.dart';
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF5A6382),
      ),
      child: const Icon(
        Icons.person,
        size: 70,
        color: Color(0xFFECEFF1),
      ),
    );
  }
}
