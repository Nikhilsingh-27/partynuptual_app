import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 🔥 IMPORTANT
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Column(
        children: [
          // HEADER WITH BG IMAGE
          Stack(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/avatar-bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Profile Avatar
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    child: const CircleAvatar(
                      radius: 34,
                      backgroundColor: Color(0xFF5B6786),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // CHAT BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                _messageBubble("whats your name", "2026-01-21 00:30:08"),
                const SizedBox(height: 28),
                _messageBubble("whats your name", "2026-01-21 00:30:09"),
              ],
            ),
          ),

          // INPUT AREA
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFEAEAEA)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Type Your Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFFFE5E5),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.red),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(text),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
