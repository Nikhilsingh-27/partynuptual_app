import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/profile_image_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class UpdateImageButton extends StatelessWidget {
  UpdateImageButton({super.key});

  final ProfileImageController imageController =
      Get.find<ProfileImageController>();
  final AuthenticationController auth = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 160,
      child: ElevatedButton(
        onPressed: () async {
          if (auth.userId == null ||
              imageController.selectedImage.value == null) {
            CustomSnackbar.showError("Please select image first");
            return;
          }

          try {
            final response = await ProfileService().updateimage(
              userId: auth.userId!,
              imageFile: imageController.selectedImage.value!,
            );

            final isSuccess =
                response['status'] == true || response['status'] == "success";

            if (isSuccess) {
              // If backend returned image url, update controller so avatar refreshes
              try {
                CustomSnackbar.showSuccess(
                  "Profile image updated successfully",
                );
                final String? imageUrl = response['image']?.toString();
                if (imageUrl != null && imageUrl.isNotEmpty) {
                  imageController.remoteImageUrl.value = imageUrl;
                }
              } catch (_) {}

              // clear local selection so avatar shows remote image
              imageController.clear();
            }
          } catch (e) {
            CustomSnackbar.showError(e.toString());
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD61F3A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Update Image",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
