import 'package:flutter/material.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:get/get.dart';
class MyIdeaScreen extends StatefulWidget {
  const MyIdeaScreen({super.key});

  @override
  State<MyIdeaScreen> createState() => _MyIdeaScreenState();
}

class _MyIdeaScreenState extends State<MyIdeaScreen> {
  bool isloading=true;
  String getLogoImageUrl(String? logoPath) {
    const String baseUrl = "https://partynuptual.com/";
    const String defaultImage =
        "${baseUrl}public/front/assets/img/list-8.jpg";

    if (logoPath == null || logoPath.trim().isEmpty) {
      return defaultImage;
    }


    final String imageName = logoPath.split('/').last;

    if (imageName.isEmpty) {
      return defaultImage;
    }

    return "${baseUrl}/public/uploads/ideas/$imageName";
  }

  final List<Map<String, String>> ideas = [
    {
      "theme": "Birthday",
      "venue": "Grand Hall",
      "description": "Fun birthday theme decoration",
      "image": "assets/b1.jpg",
      "date": "20 Jan 2026",
    },
    {
      "theme": "Wedding",
      "venue": "Royal Palace",
      "description": "Luxury wedding decor setup",
      "image": "assets/b.jpg",
      "date": "18 Jan 2026",
    },
    {
      "theme": "Corporate Event",
      "venue": "Business Center",
      "description": "Professional corporate theme",
      "image": "assets/g.jpg",
      "date": "15 Jan 2026",
    },
  ];
  final AuthenticationController auth = Get.find<AuthenticationController>();
  final List<dynamic> listmyideas = [];

  Future<void> getmyideas() async {
    try {
      final response =
      await ProfileService().getmyideafun(id: auth.userId ?? "");

      if (response == null || response["data"] == null) return;

      setState(() {
        listmyideas.clear();
        listmyideas.addAll(response["data"]);
        isloading=false;
      });
    } catch (e) {
      debugPrint("Error fetching inquiries: $e");
    }
  }

  @override
  void initState(){
    super.initState();
    getmyideas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shared Ideas"),
      ),
      body: isloading?Center(child:CircularProgressIndicator()): ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: listmyideas.length,
        itemBuilder: (context, index) {
          final idea = listmyideas[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PARTY THEME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    idea["party_theme"]!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "VENUE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    idea["venue"]!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "DESCRIPTION",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    idea["description"]!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "IMAGE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Image.network(
                    getLogoImageUrl(idea["image"]),  // fallback if null
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "DATE ADDED",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    idea["date_added"]!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color.fromRGBO(199, 21, 55, 1),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color.fromRGBO(199, 21, 55, 1),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
