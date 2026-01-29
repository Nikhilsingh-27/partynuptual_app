import 'package:flutter/material.dart';
import 'package:get/get.dart';
class BusinessListingCard extends StatelessWidget {
  final Map<String, String> item;

  const BusinessListingCard({super.key, required this.item});

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
              item["banner_img"]!,
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
                  item["business_tag_line"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                /// ACTION BUTTONS
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _actionButton(
                      icon: Icons.check_circle,
                      text: "Activate Your Listing",
                      bgColor: const Color(0xFFDFF3EA),
                      color: const Color(0xFF1E8E5A),
                      onTap: () {
                       Get.toNamed('/plan');
                      },
                    ),
                    _actionButton(
                      icon: Icons.edit,
                      text: "Edit",
                      bgColor: const Color(0xFFE9F2FF),
                      color: const Color(0xFF2563EB),
                      onTap: () {
                        debugPrint(
                            "Edit clicked: ${item["company_name"]}");
                      },
                    ),
                    _actionButton(
                      icon: Icons.delete,
                      text: "Delete",
                      bgColor: const Color(0xFFFFE5E5),
                      color: Colors.red,
                      onTap: () {
                        debugPrint(
                            "Deleted: ${item["company_name"]}");
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
