import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class InquiriesScreen extends StatefulWidget {
  const InquiriesScreen({super.key});

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  final AuthenticationController auth = Get.find<AuthenticationController>();

  bool isLoading = true;
  final List<dynamic> listInquiries = [];

  Future<void> getInquiry() async {
    try {
      final response = await ProfileService().getinquiry(id: auth.userId ?? "");

      if (response != null && response["data"] != null) {
        setState(() {
          listInquiries.clear();
          listInquiries.addAll(response["data"]);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching inquiries: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteInquiry(String id) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await ProfileService().deleteinquirifun(id: id);

      Get.back(); // close loader

      if (response["status"] == true) {
        CustomSnackbar.showSuccess(
          response["message"] ?? "Deleted successfully",
        );
        await getInquiry(); // 🔥 REFRESH LIST
      }
    } catch (e) {
      Get.back();
      debugPrint("Delete error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getInquiry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inquiries',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : listInquiries.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No Record Found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: listInquiries.length,
              itemBuilder: (context, index) {
                final inquiry = listInquiries[index];

                return Card(
                  color: Colors.grey.shade100,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inquiry['listing_name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.person, size: 16),
                            const SizedBox(width: 4),
                            Text(inquiry['name'] ?? ''),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(Icons.email, size: 16),
                            const SizedBox(width: 4),
                            Text(inquiry['email'] ?? ''),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(Icons.phone, size: 16),
                            const SizedBox(width: 4),
                            Text(inquiry['phone'] ?? ''),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          inquiry['message'] ?? '',
                          style: const TextStyle(color: Colors.black87),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          inquiry['created_date'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed: () {
                            deleteInquiry(inquiry["id"].toString());
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
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
