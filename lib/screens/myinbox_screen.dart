import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';

class MyInboxScreen extends StatefulWidget {
  const MyInboxScreen({super.key});

  @override
  State<MyInboxScreen> createState() => _MyInboxScreenState();
}

class _MyInboxScreenState extends State<MyInboxScreen> {
  final auth = Get.find<AuthenticationController>();
  late String user_id;

  List<Map<String, dynamic>> inboxList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    user_id = auth.userId ?? "";
    fetchInbox();
  }

  /// Fetch inbox using the API
  Future<void> fetchInbox() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ProfileService().getConversations(userId: user_id);

      if (response["status"] == true) {
        setState(() {
          inboxList = List<Map<String, dynamic>>.from(response["data"]);
        });
      } else {
        // No data or error
        setState(() {
          inboxList = [];
        });
        Get.snackbar("Error", response["message"] ?? "Failed to fetch inbox");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch inbox: $e");
      setState(() {
        inboxList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : inboxList.isEmpty
            ? const Center(child: Text("No Messages"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All Messages",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: inboxList.length,
                      itemBuilder: (context, index) {
                        final item = inboxList[index];
                        return _messageTile(item, index);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _messageTile(Map<String, dynamic> item, int index) {
    String vendorName = item["vendor_name"] ?? "Unknown";
    String vendorEmail = item["vendor_email"] ?? "";
    String? avatar = item["avatar"];
    String unreadCount = item["unread_count"] ?? "0";
    String user_id = item["user_id"] ?? "";
    String vendor_id = item["vendor_id"] ?? "";
    String conversation_id = item["id"] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left red indicator if unread
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: unreadCount != "0" ? Colors.red : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Profile avatar (clickable)
          GestureDetector(
            onTap: () {
              // Navigate to conversation screen
              Get.toNamed(
                '/conversation',
                arguments: {
                  "conversation_id": conversation_id,
                  "user_id": user_id,
                  "vendor_id": vendor_id,
                },
              );
            },
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF5B6786),
                  backgroundImage: avatar != null
                      ? NetworkImage(
                          "https://partynuptual.com/public/uploads/avatar/$avatar",
                        )
                      : null,
                  child: avatar == null
                      ? const Icon(Icons.person, size: 32, color: Colors.white)
                      : null,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Name & Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendorName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Remove button
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: OutlinedButton.icon(
              onPressed: () async {
                final response = await ProfileService().deleteconversationfun(
                  id: conversation_id,
                );

                if (response["status"]) {
                  setState(() {
                    inboxList.removeAt(index);
                  });

                  Get.snackbar(
                    "Success",
                    "Conversation deleted successfully",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 8,
                    duration: const Duration(seconds: 2),
                  );
                }
              },

              icon: const Icon(Icons.delete, color: Colors.red, size: 16),
              label: const Text(
                "Remove",
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
