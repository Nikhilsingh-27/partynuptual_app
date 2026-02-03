import 'package:flutter/material.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/profile_image_controller.dart';
import './avatar.dart';
import './filepicker.dart';
import './updateimg.dart';


class ProfileImageUploadContainer extends StatelessWidget {
  ProfileImageUploadContainer({super.key});

  final AuthenticationController auth = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    // ✅ Register once (safe if already registered)
    Get.put(ProfileImageController());

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(),
          const SizedBox(height: 20),
          FilePickerBox(),
          const SizedBox(height: 24),
          UpdateImageButton(),
        ],
      ),
    );
  }
}
