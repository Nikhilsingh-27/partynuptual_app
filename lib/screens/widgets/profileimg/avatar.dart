import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/profile_image_controller.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({super.key});

  final controller = Get.find<ProfileImageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF5A6382),
          image: controller.selectedImage.value != null
              ? DecorationImage(
            image: FileImage(controller.selectedImage.value!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: controller.selectedImage.value == null
            ? const Icon(Icons.person, size: 70, color: Color(0xFFECEFF1))
            : null,
      );
    });
  }
}
