import 'package:flutter/material.dart';
class UpdateImageButton extends StatelessWidget {
  const UpdateImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 160,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD61F3A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          "Update Image",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
