// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
// import 'dart:io';
//
// // Future<String?> convertImageToBase64(XFile? image) async {
// //   if (image == null) return null;
// //
// //   final bytes = await File(image.path).readAsBytes();
// //   return "data:image/jpeg;base64,$bytes";
// // }
//
// Future<String> convertImageToBase64(XFile bannerImage) async {
//   final bytes = await bannerImage.readAsBytes();
//   return base64Encode(bytes);
// }


import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Converts picked image to Base64 string
/// Returns null if conversion fails
Future<String?> convertImageToBase64(XFile? image) async {
  try {
    if (image == null) return null;

    // Read image as bytes
    final File imageFile = File(image.path);
    final List<int> imageBytes = await imageFile.readAsBytes();

    // Convert bytes to base64
    final String base64String = base64Encode(imageBytes);

    return "data:image/jpeg;base64,${base64String}";
  } catch (e) {
    print("Base64 conversion error: $e");
    return null;
  }
}
