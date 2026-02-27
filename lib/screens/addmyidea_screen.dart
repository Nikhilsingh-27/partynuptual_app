import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/home_controller.dart';
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

  // ✅ Error Flags
  bool showThemeError = false;
  bool showVenueError = false;
  bool showDescError = false;
  bool showImageError = false;

  late String ideaId;

  final TextEditingController _venueCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? existingImageUrl;

  // ================= LOAD THEMES =================
  Future<void> _loadPartyThemes() async {
    try {
      setState(() => isThemeLoading = true);
      final response = await ProfileService().getpartythemesfun();

      if (response["status"] == "success") {
        partyThemes = List<Map<String, dynamic>>.from(response["data"]);
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

  // ================= LOAD EDIT DATA =================
  Future<void> _loadIdeaDetails() async {
    final auth = Get.find<AuthenticationController>();

    try {
      final response = await ProfileService().getsingleidea(
        idea_id: ideaId,
        user_id: auth.userId!,
      );

      final idea = response["data"];

      selectedTheme = idea["party_theme"];
      _venueCtrl.text = idea["venue"] ?? "";
      _descCtrl.text = idea["description"] ?? "";

      existingImageUrl =
          "https://partynuptual.com/public/uploads/ideas/${idea["image"]}";

      setState(() {});
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

    _loadPartyThemes();

    if (ideaId.isNotEmpty) {
      _loadIdeaDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Share Your Party Idea",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= PARTY THEME =================
                  _label("Party Theme"),
                  DropdownButtonFormField<String>(
                    value: selectedTheme,
                    hint: const Text(
                      "Select Party Theme",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    items: partyThemes
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
                        showThemeError = false;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: showThemeError ? Colors.red : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: showThemeError ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  if (showThemeError)
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Party Theme is required.",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ================= VENUE =================
                  _label("Venue"),
                  _textField(
                    controller: _venueCtrl,
                    hint: "Country/City",
                    showError: showVenueError,
                    onChanged: (val) {
                      if (val.trim().isNotEmpty) {
                        setState(() => showVenueError = false);
                      }
                    },
                  ),
                  if (showVenueError)
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Venue is required.",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ================= DESCRIPTION =================
                  _label("Description"),
                  _textField(
                    controller: _descCtrl,
                    maxLines: 5,
                    showError: showDescError,
                    onChanged: (val) {
                      if (val.trim().isNotEmpty) {
                        setState(() => showDescError = false);
                      }
                    },
                  ),
                  if (showDescError)
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Description is required.",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ================= IMAGE =================
                  _label("Main Image"),
                  _filePicker(),
                  if (showImageError)
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Image is required.",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 30),

                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(199, 31, 55, 1),
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
      onTap: () async {
        await _pickImage();
        setState(() => showImageError = false);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: showImageError ? Colors.red : Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
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
                    : existingImageUrl ?? "No file chosen",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showImageError)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.error_outline, color: Colors.red, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final File file = File(image.path);

    // 🔥 Get file size in bytes
    final int fileSize = await file.length();

    // 1 MB = 1048576 bytes
    if (fileSize > 2097152) {
      CustomSnackbar.showError("Image size must be less than 2 MB");
      return; // ❌ Stop if larger than 1MB
    }

    // ✅ Valid image
    setState(() {
      selectedImage = file;
      existingImageUrl = null; // optional: remove old image if editing
    });
  }

  // ================= SUBMIT =================
  Future<void> _submitData() async {
    final auth = Get.find<AuthenticationController>();

    if (auth.userId == null || auth.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    setState(() {
      showThemeError = selectedTheme == null;
      showVenueError = _venueCtrl.text.trim().isEmpty;
      showDescError = _descCtrl.text.trim().isEmpty;
      showImageError = selectedImage == null && existingImageUrl == null;
    });

    if (showThemeError || showVenueError || showDescError || showImageError) {
      CustomSnackbar.showError("Please fill all required fields");
      return;
    }

    try {
      CustomSnackbar.showSuccess("Please wait..");

      late Map<String, dynamic> response;

      if (ideaId.isEmpty) {
        response = await ProfileService().submitideafun(
          party_theme: selectedTheme!,
          venue: _venueCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          user_id: auth.userId!,
          image: selectedImage!,
        );
      } else {
        response = await ProfileService().editmyidea(
          party_theme: selectedTheme!,
          venue: _venueCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          user_id: auth.userId!,
          idea_id: ideaId,
          image: selectedImage,
        );
      }

      if (response['status'] == true || response['status'] == "success") {
        CustomSnackbar.showSuccess("Success");
        final homeController = Get.find<HomeController>();

        await homeController.fetchHomeData(); // 🔥 REF
        if (ideaId.isEmpty) {
          _venueCtrl.clear();
          _descCtrl.clear();
          setState(() {
            selectedTheme = null;
            selectedImage = null;
          });
        } else {
          Get.back();
        }
      } else {
        CustomSnackbar.showError(response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    }
  }

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
    bool showError = false,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        suffixIcon: showError
            ? const Icon(Icons.error_outline, color: Colors.red)
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: showError ? Colors.red : Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: showError ? Colors.red : Colors.black),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _venueCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
}
