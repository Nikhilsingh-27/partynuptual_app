import 'package:flutter/material.dart';

class InquiriesScreen extends StatelessWidget {
  InquiriesScreen({super.key});

  // Dummy data for demonstration
  final List<Map<String, String>> inquiries = [
    {
      "listing": "Mocktails & Cocktails",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "1234567890",
      "message": "I am interested in your services.",
      "date": "2026-01-23"
    },
    {
      "listing": "Lolita Restaurant",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "phone": "9876543210",
      "message": "Can I book a table for 2?",
      "date": "2026-01-22"
    },
    {
      "listing": "Coffee Corner",
      "name": "Mike Johnson",
      "email": "mike@example.com",
      "phone": "5555555555",
      "message": "Do you offer online delivery?",
      "date": "2026-01-21"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiries'),
        backgroundColor: Colors.white,
      ),
      body: inquiries.isEmpty
          ? const Center(
        child: Text(
          "No inquiries found yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: inquiries.length,
        itemBuilder: (context, index) {
          final inquiry = inquiries[index];
          return Card(
            color: Colors.white,
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
                    inquiry['listing'] ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      inquiry['date'] ?? '',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),
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
