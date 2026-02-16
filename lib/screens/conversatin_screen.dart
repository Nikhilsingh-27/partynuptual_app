import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_app/data/services/profile_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Timer? _timer;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String conversationId;
  late String userId;
  late String receiverId;

  List messages = [];

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};
    conversationId = args["conversation_id"] ?? "";
    userId = args["user_id"] ?? "";
    receiverId = args["vendor_id"] ?? "";

    _loadMessages();
    _startAutoRefresh();
  }

  // ===============================
  // FETCH MESSAGES
  // ===============================
  Future<void> _loadMessages() async {
    try {
      final response = await ProfileService().fetchconversationfun(
        id: conversationId,
        user_id: userId,
      );

      if (response["status"] == true) {
        setState(() {
          messages = response["data"];
        });

        _scrollToBottom();
      }
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  // ===============================
  // SEND MESSAGE
  // ===============================
  Future<void> _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    // ✅ CLEAR UI IMMEDIATELY
    _messageController.clear();
    FocusScope.of(context).unfocus();

    try {
      final response = await ProfileService().sendmessagefun(
        id: conversationId,
        user_id: userId,
        receiver_id: receiverId,
        message: text,
      );

      if (response["status"] == true) {
        _loadMessages(); // refresh after send
      }
    } catch (e) {
      print("Send error: $e");
    }
  }

  // ===============================
  // AUTO REFRESH
  // ===============================
  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _loadMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ===============================
  // SCROLL TO BOTTOM
  // ===============================
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ===============================
  // FORMAT DATE TIME
  // ===============================
  String formatDateTime(String dateTimeString) {
    DateTime dt = DateTime.parse(dateTimeString);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: const Text("Chat"), backgroundColor: Colors.red),

      body: Column(
        children: [
          // ================= CHAT BODY =================
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isMe = message["sender_id"] == userId;

                return _messageBubble(
                  message["message"],
                  formatDateTime(message["created_at"]),
                  isMe,
                );
              },
            ),
          ),

          // ================= INPUT =================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
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
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Type Your Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFFFE5E5),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.red),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // MESSAGE BUBBLE
  // ===============================
  Widget _messageBubble(String text, String time, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? Colors.red.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(text),
          ),
          Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
