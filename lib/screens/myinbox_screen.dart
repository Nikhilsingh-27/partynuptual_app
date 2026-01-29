import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MyInboxScreen extends StatefulWidget {
  const MyInboxScreen({super.key});

  @override
  State<MyInboxScreen> createState() => _MyInboxScreenState();
}

class _MyInboxScreenState extends State<MyInboxScreen> {
  // Dummy inbox list
  final List<String> inboxUsers = List.generate(20, (index) => "User $index");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "All Messages",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: inboxUsers.length,
                itemBuilder: (context, index) {
                  return _messageTile(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageTile(int index) {
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
          // Left red indicator
          Container(
            width: 4,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Profile avatar (clickable)
          GestureDetector(
            onTap: () {
              Get.toNamed('/conversation');
            },
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF5B6786),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
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

          const Spacer(),

          // Remove button
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  inboxUsers.removeAt(index);
                });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 16, // slightly smaller icon
              ),
              label: const Text(
                "Remove",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13, // smaller text
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 36), // 👈 controls height
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4, // 👈 reduces height
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

// Placeholder screen for future navigation
class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(
        child: Text(
          "Profile Screen (Coming Soon)",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
