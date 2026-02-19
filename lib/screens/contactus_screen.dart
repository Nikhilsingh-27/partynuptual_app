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
  Future<void> _sendMessage() async {
    try {
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String phone = phoneController.text.trim();
      String subject = subjectController.text.trim();
      String message = queryController.text.trim();

      bool isEmailValid = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(email);

      // ✅ International phone validation (7–16 digits, optional +)
      bool isPhoneValid = RegExp(r'^\+?[0-9]{7,16}$').hasMatch(phone);

      if (name.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          subject.isEmpty ||
          message.isEmpty) {
        CustomSnackbar.showError("Please fill all required fields");
      } else if (!isEmailValid) {
        CustomSnackbar.showError("Please enter a valid email address");
      } else if (!isPhoneValid) {
        CustomSnackbar.showError("Please enter a valid phone number");
      } else {
        // handle response here

        final response = await HomeService().contactus(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          subject: subjectController.text.trim(),
          message: queryController.text.trim(),
        );

        print(response);
        if (response["status"] == "success") {
          CustomSnackbar.showSuccess("Message sent successfully");
          // Clear fields
          nameController.clear();
          emailController.clear();
          phoneController.clear();
          subjectController.clear();
          queryController.clear();
        }
      }
    } catch (e) {
      CustomSnackbar.showError("Failed to send message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contact form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                                  child: _field("Your Name", nameController),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _field("Email ID", emailController),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _field("Your Name", nameController),
                                const SizedBox(height: 16),
                                _field("Email ID", emailController),
                              ],
                            ),
                      const SizedBox(height: 20),
                      isWide
                          ? Row(
                              children: [
                                Expanded(
                                  child: _field("Phone No.", phoneController),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _field("Subject", subjectController),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _field("Phone No.", phoneController),
                                const SizedBox(height: 16),
                                _field("Subject", subjectController),
                              ],
                            ),
                      const SizedBox(height: 20),
                      _field(
                        "Your Query",
                        queryController,
                        maxLines: 6,
                        height: 180,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
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
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD11A2A),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Bottom section (unchanged)
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
    double height = 56,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black, width: 1.2),
              ),
            ),
          ),
        ),
      ],
    );
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
}
