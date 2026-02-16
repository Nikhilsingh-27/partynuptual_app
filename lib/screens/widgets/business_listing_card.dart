import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/editlisting_screen.dart';
import 'package:new_app/screens/plan_screen.dart';

class BusinessListingCard extends StatelessWidget {
  final VoidCallback onDeleteSuccess;
  final Map<String, dynamic> item;

  const BusinessListingCard({
    super.key,
    required this.item,
    required this.onDeleteSuccess,
  });
  String getLogoImageUrl(String? logoPath) {
    const String baseUrl = "https://partynuptual.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (logoPath == null || logoPath.trim().isEmpty) {
      return defaultImage;
    }

    final String imageName = logoPath.split('/').last;

    if (imageName.isEmpty) {
      return defaultImage;
    }

    return "${baseUrl}/public/uploads/logo/$imageName";
  }

  void _showDeleteDialog(BuildContext context, String listingId) {
    TextEditingController deleteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Type DELETE to permanently remove this listing."),
              const SizedBox(height: 10),
              TextField(
                controller: deleteController,
                decoration: const InputDecoration(
                  hintText: "Type DELETE here",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                if (deleteController.text.trim() == "DELETE") {
                  Navigator.pop(context);

                  try {
                    final response = await ProfileService().deletelistingfun(
                      id: listingId,
                    );

                    debugPrint("Delete Response: $response");
                    //final controller = Get.find<HomeController>();
                    onDeleteSuccess();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Listing deleted successfully"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please type DELETE correctly"),
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              getLogoImageUrl(item["logo_image"]!),
              height: 160,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 16),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["company_name"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  item["tag_line"]!,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    item["status"] == "1"
                        ? _actionButton(
                            icon: Icons.check_circle,
                            text: "Listing is Activated",
                            bgColor: const Color(0xFFDFF3EA),
                            color: const Color(0xFF1E8E5A),
                            onTap: () {
                              // Optional: do nothing or show a message
                            },
                          ):_actionButton(
                      icon: Icons.check_circle,
                      text: "Activate Your Listing",
                      bgColor: const Color(0xFFDFF3EA),
                      color: const Color(0xFF1E8E5A),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PricingScreen(
                              id: item["listing_id"] ?? "",
                            ),
                          ),
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.edit,
                      text: "Edit",
                      bgColor: const Color(0xFFE9F2FF),
                      color: const Color(0xFF2563EB),
                      onTap: () {
                        Get.to(EditListingScreen(data: item));
                      },
                    ),
                    _actionButton(
                      icon: Icons.delete,
                      text: "Delete",
                      bgColor: const Color(0xFFFFE5E5),
                      color: Colors.red,
                      onTap: () {
                        _showDeleteDialog(context, item["listing_id"]);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String text,
    required Color bgColor,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
