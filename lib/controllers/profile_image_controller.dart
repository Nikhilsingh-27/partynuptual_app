
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  // store remote image URL returned from backend after upload
  final RxString remoteImageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }
  void clear() {
    selectedImage.value = null;

  }
}
