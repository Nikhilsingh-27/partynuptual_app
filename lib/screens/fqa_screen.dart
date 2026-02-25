import 'package:flutter/material.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/faq.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<FAQItem> allFAQs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFAQs();
  }

  Future<void> fetchFAQs() async {
    try {
      final response = await ProfileService().faqfun();

      if (response["status"] == true) {
        final data = response["data"];

        final vendorList = List<Map<String, dynamic>>.from(
          data["vendor_faqs"] ?? [],
        );

        final customerList = List<Map<String, dynamic>>.from(
          data["customer_faqs"] ?? [],
        );

        List<FAQItem> combinedList = [...vendorList, ...customerList].map((
          item,
        ) {
          return FAQItem(
            question: item["heading"] ?? "",
            answer: _stripHtml(item["description"] ?? ""),
          );
        }).toList();

        setState(() {
          allFAQs = combinedList;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String _stripHtml(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll("&nbsp;", " ")
        .replaceAll("&#39;", "'")
        .replaceAll("&amp;", "&")
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// ✅ APP BAR TITLE ONLY
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Vendor FAQ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: FAQWidget(
                        title: "", // 🔥 No section title now
                        items: allFAQs,
                      ),
                    ),
                    const BottomSection(),
                  ],
                ),
              ),
      ),
    );
  }
}
