import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import './controllers/authentication_controller.dart';
import 'screens/home_page.dart';
import 'screens/widgets/custom_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize app-wide controllers after storage is ready.
  Get.put(AuthenticationController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();

    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (uri.host == "paypal-success") {
        Get.offAll(() => HomePage());
      }

      if (uri.host == "paypal-cancel") {
        CustomSnackbar.showError("Payment Cancelled");
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // Function to open WhatsApp
  void openWhatsApp() async {
    String url =
        'https://api.whatsapp.com/send/?text=Party+Nuptual+Book+Wedding+Event+Services+https%3A%2F%2Fpartynuptual.com%2F';

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
        brightness: Brightness.light,
        fontFamily: 'Jost',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      builder: (context, child) {
        return Stack(children: [child!]);
      },
    );
  }
}
