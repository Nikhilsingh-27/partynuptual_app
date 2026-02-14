import 'package:flutter/material.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:get/get.dart';


class InquiriesScreen extends StatefulWidget {
  const InquiriesScreen({super.key});

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  final AuthenticationController auth = Get.find<AuthenticationController>();

  bool isloading=true;
  final List<dynamic> listinquiries = [];

  Future<void> getinquiry() async {
    try {
      final response =
      await ProfileService().getinquiry(id: auth.userId ?? "");

      if (response == null || response["data"] == null) return;

      setState(() {
        listinquiries.clear();
        listinquiries.addAll(response["data"]);
        isloading=false;
      });
    } catch (e) {
      debugPrint("Error fetching inquiries: $e");
    }
  }

  @override
  void initState(){
    super.initState();
    getinquiry();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiries'),
        backgroundColor: Colors.white,
      ),
      body: isloading?Center(child: CircularProgressIndicator(),): listinquiries.isEmpty
    ? const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_outlined,
          size: 60,
          color: Colors.grey,
        ),
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
        :ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: listinquiries.length,
        itemBuilder: (context, index) {
          final inquiry = listinquiries[index];
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
                    inquiry['listing_name'] ?? '',
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
                      inquiry['created_date'] ?? '',
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
