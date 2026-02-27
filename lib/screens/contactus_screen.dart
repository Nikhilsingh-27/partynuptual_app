import 'package:flutter/material.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController queryController = TextEditingController();

  // Error states
  bool nameError = false;
  bool emailError = false;
  bool phoneError = false;
  bool subjectError = false;
  bool messageError = false;

  String? nameErrorText;
  String? emailErrorText;
  String? phoneErrorText;
  String? subjectErrorText;
  String? messageErrorText;

  Future<void> _sendMessage() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String subject = subjectController.text.trim();
    String message = queryController.text.trim();

    bool isEmailValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);

    bool isPhoneValid = RegExp(r'^\+?[0-9]{7,16}$').hasMatch(phone);

    setState(() {
      nameError = name.isEmpty;
      emailError = email.isEmpty || !isEmailValid;
      phoneError = phone.isEmpty || !isPhoneValid;
      subjectError = subject.isEmpty;
      messageError = message.isEmpty;

      nameErrorText = name.isEmpty ? "Name is required" : null;

      if (email.isEmpty) {
        emailErrorText = "Email is required";
      } else if (!isEmailValid) {
        emailErrorText = "Enter a valid email address";
      } else {
        emailErrorText = null;
      }

      if (phone.isEmpty) {
        phoneErrorText = "Phone number is required";
      } else if (!isPhoneValid) {
        phoneErrorText = "Enter a valid phone number";
      } else {
        phoneErrorText = null;
      }

      subjectErrorText = subject.isEmpty ? "Subject is required" : null;
      messageErrorText = message.isEmpty ? "Message is required" : null;
    });

    // ✅ If any field empty → Show snackbar
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        subject.isEmpty ||
        message.isEmpty) {
      CustomSnackbar.showError("All fields are required");
      return;
    }

    // ✅ Specific format validation snackbar
    if (!isEmailValid) {
      CustomSnackbar.showError("Please enter a valid email address");
      return;
    }

    if (!isPhoneValid) {
      CustomSnackbar.showError("Please enter a valid phone number");
      return;
    }

    try {
      final response = await HomeService().contactus(
        name: name,
        email: email,
        phone: phone,
        subject: subject,
        message: message,
      );

      if (response["status"] == "success") {
        CustomSnackbar.showSuccess("Message sent successfully");

        nameController.clear();
        emailController.clear();
        phoneController.clear();
        subjectController.clear();
        queryController.clear();
      } else {
        CustomSnackbar.showError("Failed to send message");
      }
    } catch (e) {
      CustomSnackbar.showError("Something went wrong. Please try again.");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isWide
                          ? Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    "Your Name",
                                    nameController,
                                    isError: nameError,
                                    errorText: nameErrorText,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _field(
                                    "Email ID",
                                    emailController,
                                    isError: emailError,
                                    errorText: emailErrorText,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _field(
                                  "Your Name",
                                  nameController,
                                  isError: nameError,
                                  errorText: nameErrorText,
                                ),
                                const SizedBox(height: 16),
                                _field(
                                  "Email ID",
                                  emailController,
                                  isError: emailError,
                                  errorText: emailErrorText,
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),
                      isWide
                          ? Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    "Phone No.",
                                    phoneController,
                                    isError: phoneError,
                                    errorText: phoneErrorText,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _field(
                                    "Subject",
                                    subjectController,
                                    isError: subjectError,
                                    errorText: subjectErrorText,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _field(
                                  "Phone No.",
                                  phoneController,
                                  isError: phoneError,
                                  errorText: phoneErrorText,
                                ),
                                const SizedBox(height: 16),
                                _field(
                                  "Subject",
                                  subjectController,
                                  isError: subjectError,
                                  errorText: subjectErrorText,
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),
                      _field(
                        "Your Query",
                        queryController,
                        maxLines: 6,
                        isError: messageError,
                        errorText: messageErrorText,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _sendMessage,
                          icon: const Icon(
                            Icons.send,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Send Message",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD11A2A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            BottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool isError = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            // ✅ Border always visible
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isError ? Colors.red : Colors.black,
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isError ? Colors.red : Colors.black,
                width: 1.2,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
