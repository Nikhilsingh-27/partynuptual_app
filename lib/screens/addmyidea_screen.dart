import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class AddMyIdeaScreen extends StatefulWidget {
  const AddMyIdeaScreen({super.key});

  @override
  State<AddMyIdeaScreen> createState() => _AddMyIdeaScreenState();
}

class _AddMyIdeaScreenState extends State<AddMyIdeaScreen> {
  bool isloading = true;
  List<Map<String, dynamic>> partyThemes = [];
  String? selectedTheme;
  bool isThemeLoading = false;

  Future<void> _loadPartyThemes() async {
    try {
      setState(() => isThemeLoading = true);

      final response = await ProfileService().getpartythemesfun();

      if (response["status"] == "success") {
        partyThemes = List<Map<String, dynamic>>.from(response["data"]);

        // EDIT MODE: keep already selected theme
        if (selectedTheme != null &&
            partyThemes.any((e) => e["id"] == selectedTheme)) {
          // keep it
        } else {
          selectedTheme = null;
        }
      }
    } catch (e) {
      CustomSnackbar.showError("Failed to load party themes");
    } finally {
      setState(() {
        isThemeLoading = false;
        isloading = false;
      });
    }
  }

  late String ideaId;

  final TextEditingController _themeCtrl = TextEditingController();
  final TextEditingController _venueCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  String? existingImageUrl;
  Future<void> _loadIdeaDetails() async {
    final auth = Get.find<AuthenticationController>();

    try {
      final response = await ProfileService().getsingleidea(
        idea_id: ideaId,
        user_id: auth.userId!,
      );

      final idea = response["data"];

      selectedTheme = idea["party_theme"] ?? "";
      _venueCtrl.text = idea["venue"] ?? "";
      _descCtrl.text = idea["description"] ?? "";

      setState(() {
        existingImageUrl =
            "https://partynuptual.com/public/uploads/ideas/${idea["image"]}";
      });
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    ideaId = args != null && args["idea_id"] != null
        ? args["idea_id"].toString()
        : "";

    _loadPartyThemes(); // 👈 always load dropdown data

    if (ideaId.isNotEmpty) {
      _loadIdeaDetails(); // 👈 edit mode
    }
  }

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
                color: Color.fromRGBO(226, 55, 68, 1),
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

      body: isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Party Theme"),
                  isThemeLoading
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<String>(
                          value: selectedTheme,
                          hint: const Text("Select Party Theme"),
                          items: partyThemes
                              .where((e) => e["id"] != "")
                              .map(
                                (theme) => DropdownMenuItem<String>(
                                  value: theme["id"],
                                  child: Text(theme["name"]),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTheme = value;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),

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
                          backgroundColor: Color.fromRGBO(199, 31, 55, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _submitData,
                        child: Text(
                          ideaId.isEmpty ? "Submit Idea" : "Update Idea",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                selectedImage != null
                    ? selectedImage!.path.split('/').last
                    : existingImageUrl != null
                    ? existingImageUrl!.split('/').last
                    : "No file chosen",
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
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });

      print("Image selected: ${image.path}");
    }
  }

  // ================= SUBMIT =================
  Future<void> _submitData() async {
    final AuthenticationController auth = Get.find<AuthenticationController>();

    if (auth.userId == null || auth.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    if (selectedTheme == null ||
        _venueCtrl.text.isEmpty ||
        _descCtrl.text.isEmpty) {
      CustomSnackbar.showError("All fields are required");
      return;
    }

    if (selectedImage == null && existingImageUrl == null) {
      CustomSnackbar.showError("Please select an image");
      return;
    }

    try {
      CustomSnackbar.showSuccess("Please wait..");
      late Map<String, dynamic> response;

      // 🆕 ADD MODE
      if (ideaId.isEmpty) {
        response = await ProfileService().submitideafun(
          party_theme: selectedTheme!,
          venue: _venueCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          user_id: auth.userId!,
          image: selectedImage!, // must exist in add
        );
      }
      // ✏️ EDIT MODE
      else {
        response = await ProfileService().editmyidea(
          party_theme: selectedTheme!,
          venue: _venueCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          user_id: auth.userId!,
          idea_id: ideaId,
          image: selectedImage, // nullable ✔
        );
      }

      if (response['status'] == true || response['status'] == "success") {
        CustomSnackbar.showSuccess("Party idea submitted successfully");

        // Clear only in ADD mode
        if (ideaId.isEmpty) {
          _themeCtrl.clear();
          _venueCtrl.clear();
          _descCtrl.clear();
          setState(() {
            selectedImage = null;
          });
        } else {
          Get.back(); // go back after edit
        }
      } else {
        CustomSnackbar.showError(response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    }
  }

  // ================= UI HELPERS =================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
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
