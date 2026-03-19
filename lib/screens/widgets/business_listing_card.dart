import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/editlisting_screen.dart';
import 'package:new_app/screens/plan_screen.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class BusinessListingCard extends StatefulWidget {
  final VoidCallback onDeleteSuccess;
  final Map<String, dynamic> item;

  const BusinessListingCard({
    super.key,
    required this.item,
    required this.onDeleteSuccess,
  });

  @override
  State<BusinessListingCard> createState() => _BusinessListingCardState();
}

class _BusinessListingCardState extends State<BusinessListingCard> {
  Widget _buildStatusBadge() {
    final String status = widget.item["status"]?.toString() ?? "";
    final String? validDate = widget.item["listing_valid_date"];

    if (status == "1") {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2E8B57),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "Active",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (status == "0" &&
        validDate != null &&
        validDate.toString().trim().isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFdc3545),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "Expired",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return const SizedBox(); // show nothing
  }

  int calculateDaysLeftFromToday(String validDate) {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      DateTime parsed = DateTime.parse(validDate);
      DateTime expiryDate = DateTime(parsed.year, parsed.month, parsed.day);

      int daysLeft = expiryDate.difference(today).inDays;

      return daysLeft < 0 ? 0 : daysLeft;
    } catch (e) {
      return 0;
    }
  }

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
                    widget.onDeleteSuccess();

                    CustomSnackbar.showSuccess("Listing deleted successfully");
                  } catch (e) {
                    CustomSnackbar.showError(e.toString());
                  }
                } else {
                  CustomSnackbar.showError("Please type DELETE correctly");
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
    int paypalsetting = 1;
  Future<int> paypayfun() async {
    try {
      final response = await ProfileService().paypalsetting();

      if (response["success"] == true) {
        return response["paypal_setting"] ?? 1;
      } else {
        return 1;
      }
    } catch (e) {
      print("Paypal Error: $e");
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    loadPaypalSetting(); // ✅ call async function
  }
   Future<void> loadPaypalSetting() async {
    final value = await paypayfun();

    setState(() {
      paypalsetting = value;
      print("rr");
      print(paypalsetting);
    });
   }
  @override
  Widget build(BuildContext context) {
    final int daysLeft = calculateDaysLeftFromToday(
      widget.item["listing_valid_date"] ?? "",
    );

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
              getLogoImageUrl(widget.item["logo_image"]!),
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
                _buildStatusBadge(),
                Text(
                  widget.item["company_name"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  widget.item["tag_line"]!,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),

                const SizedBox(height: 8),
                if (widget.item["status"] == "1")
                  Text(
                    "Listing active - $daysLeft days left",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (widget.item["status"] != "1")
                      _actionButton(
                        icon: Icons.check_circle,
                        text: "Activate Your Listing",
                        bgColor: const Color(0xFFDFF3EA),
                        color: const Color(0xFF1E8E5A),
                        onTap: () async {
                          try {
                            if (paypalsetting == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PricingScreen(
                                    id: widget.item["listing_id"] ?? "",
                                  ),
                                ),
                              );
                              return;
                            }

                            final activateResponse = await ProfileService()
                                .activatelistingfun(
                                  id:
                                      widget.item["listing_id"]?.toString() ??
                                      "",
                                );

                            CustomSnackbar.showSuccess(
                              "Listing activated successfully",
                            );
                            debugPrint(
                              "Activate Listing Response: $activateResponse",
                            );

                            // Refresh parent list / page data after activation call.
                            widget.onDeleteSuccess();
                          } catch (e) {
                            CustomSnackbar.showError(e.toString());
                          }
                        },
                      ),

                    _actionButton(
                      icon: Icons.edit,
                      text: "Edit",
                      bgColor: const Color(0xFFE9F2FF),
                      color: const Color(0xFF2563EB),
                      onTap: () async {
                        final result = await Get.to(
                          () => EditListingScreen(data: widget.item),
                        );

                        if (result == true) {
                          widget.onDeleteSuccess(); // this calls fetchlisting()
                        }
                      },
                    ),
                    _actionButton(
                      icon: Icons.delete,
                      text: "Delete",
                      bgColor: const Color(0xFFFFE5E5),
                      color: Colors.red,
                      onTap: () {
                        _showDeleteDialog(context, widget.item["listing_id"]);
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
