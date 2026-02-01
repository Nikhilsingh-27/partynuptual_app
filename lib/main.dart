import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './controllers/authentication_controller.dart';



void main() {
  Get.put(AuthenticationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Function to open WhatsApp
  void openWhatsApp() async {
    //String phone = '+911234567890'; // Replace with your WhatsApp number
    //String message = Uri.encodeComponent("Hello, I want to chat with you!");
    String url = 'https://api.whatsapp.com/send/?text=Party+Nuptual+%E2%80%93+Book+Wedding%2C+Event+%26+Party+Services+Online+https%3A%2F%2Fpartynuptual.com%2F&type=custom_url&app_absent=0';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vendor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      builder: (context, child) {
        // Wrap all screens with Stack to show WhatsApp button globally
        return Stack(
          children: [
            child!, // Your app pages
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: openWhatsApp,
                backgroundColor: Colors.green,
                child: const FaIcon(FontAwesomeIcons.whatsapp),
              ),
            ),
          ],
        );
      },
    );
  }
}
