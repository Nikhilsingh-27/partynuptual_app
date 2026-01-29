import 'package:flutter/material.dart';
import './avatar.dart';
import './filepicker.dart';
import './updateimg.dart';
class ProfileImageUploadContainer extends StatelessWidget {
  const ProfileImageUploadContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ProfileAvatar(),
          SizedBox(height: 20),
          FilePickerBox(),
          SizedBox(height: 24),
          UpdateImageButton(),
        ],
      ),
    );
  }
}
