import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/profile_image_controller.dart';


class FilePickerBox extends StatelessWidget {
  FilePickerBox({super.key});

  final controller = Get.find<ProfileImageController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black)),
              ),
              child: const Text("Choose file"),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => Text(
                controller.selectedImage.value == null
                    ? "No file chosen"
                    : "Image selected",
                style: const TextStyle(color: Colors.grey),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
