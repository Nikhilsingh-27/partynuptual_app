import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMyIdeaScreen extends StatefulWidget {
  const AddMyIdeaScreen({super.key});

  @override
  State<AddMyIdeaScreen> createState() => _AddMyIdeaScreenState();
}

class _AddMyIdeaScreenState extends State<AddMyIdeaScreen> {
  final TextEditingController _themeCtrl = TextEditingController();
  final TextEditingController _venueCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(226, 55, 68,1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Text("Share Your Party Idea"),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Party Theme"),
            _textField(controller: _themeCtrl, hint: "Party Theme"),

            const SizedBox(height: 16),

            _label("Venue"),
            _textField(controller: _venueCtrl, hint: "Country/City"),

            const SizedBox(height: 16),

            _label("Description"),
            _textField(controller: _descCtrl, maxLines: 5),

            const SizedBox(height: 20),

            _label("Main Image"),
            _filePicker(),

            const SizedBox(height: 30),

            Center(
              child: SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(199, 31, 55,1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitData,
                  child: const Text(
                    "Submit Idea",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FILE PICKER =================
  Widget _filePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black)),
              ),
              child: const Text("Choose file"),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedImage == null
                    ? "No file chosen"
                    : selectedImage!.path.split('/').last,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= IMAGE PICK FUNCTION =================
  Future<void> _pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });

      print("Image selected: ${image.path}");
    }
  }

  // ================= SUBMIT =================
  void _submitData() {
    print("========== PARTY IDEA SUBMITTED ==========");
    print("Party Theme: ${_themeCtrl.text}");
    print("Venue: ${_venueCtrl.text}");
    print("Description: ${_descCtrl.text}");
    print("Image Path: ${selectedImage?.path ?? "No Image Selected"}");
    print("==========================================");
  }

  // ================= UI HELPERS =================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _themeCtrl.dispose();
    _venueCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
}
