import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSection extends StatefulWidget {
  const BottomSection({super.key});

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  final TextEditingController email = TextEditingController();

  Future<void> _subscribe() async {
    if (email.text.trim().isEmpty || !email.text.contains("@")) {
      CustomSnackbar.showError("Please enter a valid email");
      return;
    }

    try {
      final response = await HomeService().subscribefun(
        email: email.text.trim(),
      );

      if (response["status"] == "success" &&
          response["message"] != "You are already subscribed") {
        CustomSnackbar.showSuccess("Successfully subscribed");
        email.clear();
      } else {
        CustomSnackbar.showError(response["message"] ?? "Subscription failed");
        email.clear();
      }
    } catch (e) {
      CustomSnackbar.showError("Failed to subscribe");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Newsletter Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(color: Colors.red[700]),
          child: Column(
            children: [
              const Text(
                'Subscribe To Our Newsletter!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Subscribe to our marketing platforms for the latest updates',
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: email,
                        style: TextStyle(color: Colors.grey[900]),
                        decoration: InputDecoration(
                          hintText: 'Your Email Here...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      _subscribe();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send, size: 18),
                        SizedBox(width: 6),
                        Text('Subscribe'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Footer Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logo.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Center(
                        child: Text(
                          'NP\nPARTY\nNUPTUAL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Copyright
              Text(
                '© PartyNuptual 2025',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              const SizedBox(height: 16),

              // Social Icons
              Row(
                children: [
                  Row(
                    children: [
                      _buildSocialIcon(
                        icon: Icons.facebook,
                        url: 'https://www.facebook.com/Partynuptual',
                      ),
                      const SizedBox(width: 12),
                      _buildSocialIcon(
                        icon: FontAwesomeIcons.twitter,
                        url: 'https://x.com/partynuptual',
                      ),
                      const SizedBox(width: 12),
                      _buildSocialIcon(
                        icon: FontAwesomeIcons.instagram,
                        url: 'https://www.instagram.com/partynuptual1/',
                      ),
                      const SizedBox(width: 12),
                      _buildSocialIcon(
                        icon: FontAwesomeIcons.linkedinIn,
                        url:
                            'https://www.linkedin.com/posts/party-nuptual_bartending-beverages-drinks-activity-7135975104554881024-YVeL',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Links
              const Text(
                'IMPORTANT LINKS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _buildFooterLink('Terms & Condition'),
              _buildFooterLink('Privacy Policy'),
              _buildFooterLink('Disclaimer'),
              _buildFooterLink("Faq's"),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildSocialIcon({required IconData icon, required String url}) {
  return InkWell(
    onTap: () async {
      final uri = Uri.parse(url);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $uri');
      }
    },

    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );
}

Widget _buildFooterLink(String text) {
  return InkWell(
    onTap: () {
      if (text == "Terms & Condition") {
        Get.toNamed("terms");
      }
      if (text == "Privacy Policy") {
        Get.toNamed("privacypolicy");
      }
      if (text == "Disclaimer") {
        Get.toNamed("disclaimer");
      }
      if (text == "Faq's") {
        Get.toNamed("faq");
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
      ),
    ),
  );
}
