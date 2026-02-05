import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/profile_image_controller.dart';

class ProfileAvatar extends StatelessWidget {
  final String imgurl;

  ProfileAvatar({
    super.key,
    required this.imgurl,
  });

  final controller = Get.find<ProfileImageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ImageProvider? imageProvider;

      // 1️⃣ If user selected new image (local file)
      if (controller.selectedImage.value != null) {
        imageProvider = FileImage(controller.selectedImage.value!);
      }
      // 2️⃣ Else if backend image exists
      else if (controller.remoteImageUrl.value.isNotEmpty) {
        imageProvider = NetworkImage(controller.remoteImageUrl.value);
      } else if (imgurl.isNotEmpty) {
        imageProvider = NetworkImage(imgurl);
      }

      return Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF5A6382),
          image: imageProvider != null
              ? DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: imageProvider == null
            ? const Icon(
          Icons.person,
          size: 70,
          color: Color(0xFFECEFF1),
        )
            : null,
      );
    });
  }
}
