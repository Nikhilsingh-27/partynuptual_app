import 'package:flutter/material.dart';
class FilePickerBox extends StatelessWidget {
  const FilePickerBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              border: Border(
                right: BorderSide(color: Colors.black),
              ),
            ),
            child: const Text(
              "Choose file",
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "No file chosen",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
