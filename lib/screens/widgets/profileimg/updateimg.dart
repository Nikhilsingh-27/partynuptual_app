import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/profile_image_controller.dart';
import 'package:new_app/data/services/profile_service.dart';


class UpdateImageButton extends StatelessWidget {
  UpdateImageButton({super.key});

  final ProfileImageController imageController = Get.find<ProfileImageController>();
  final AuthenticationController auth = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    print(auth.userId);
    return SizedBox(
      height: 45,
      width: 160,
      child: ElevatedButton(
        onPressed: () async {
          if (auth.userId == null || imageController.base64Image.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please select image first"),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          try {
            final response = await ProfileService().updateimage(
              user_id: auth.userId!,
              profile_image: imageController.base64Image.value,
            );
            print(response);
            final isSuccess =
                response['status'] == true || response['status'] == "success";

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isSuccess
                    ? "Profile image updated successfully"
                    : response['message'] ?? "Update failed"),
                backgroundColor:
                isSuccess ? Colors.green : Colors.red,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD61F3A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          "Update Image",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
