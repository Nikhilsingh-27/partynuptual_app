import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/vendordesc.dart';

class BusinessDetailPage extends StatefulWidget {
  const BusinessDetailPage({super.key});

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController commentCtrl = TextEditingController();

  final String businessName = "New Bay Design";
  final String location =
      "2515 Santa Clara Ave Alameda, CA 94501 Serving Alameda Area";
  final String phone = "5106314056";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Business Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// 🔹 ADDED BY VENDOR HEADER

            /// 🔹 MAIN CONTENT
            Center(
              child: SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    /// BUSINESS HEADER
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _cardDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            businessName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(location,
                                    style: const TextStyle(color: Colors.grey)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.verified,
                                  color: Colors.green, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Verified Listing",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text("Chat Now"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink.shade50,
                                foregroundColor: Colors.red,
                                elevation: 0,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const ListingDetailsDropdown(),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: _cardDecoration(),
                      clipBehavior: Clip.antiAlias, // 🔥 IMPORTANT
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 180),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/avatar-bg.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          color: Colors.white.withOpacity(0.30),
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person, size: 40, color: Colors.white),
                              ),
                              SizedBox(height: 8),
                              Text("Added By", style: TextStyle(color: Colors.grey)),
                              Text(
                                "Vendor",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
                    /// CONTACT DETAILS
                    _sectionCard(
                      Column(
                        children: [
                          _infoRow(Icons.phone, phone),
                          const SizedBox(height: 12),
                          _infoRow(Icons.location_on, location),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// SEND INQUIRY
                    _sectionCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Send Business Inquiry",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _input(nameCtrl, "Your Name"),
                          const SizedBox(height: 12),
                          _input(emailCtrl, "Your Email"),
                          const SizedBox(height: 12),
                          _input(phoneCtrl, "Your Phone"),
                          const SizedBox(height: 12),
                          _input(commentCtrl, "Leave a comment", maxLines: 4),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.send),
                              label: const Text("Send Inquiry"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            /// 🔹 BOTTOM
            BottomSection(),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  );

  Widget _sectionCard(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration(),
    child: child,
  );

  Widget _infoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 18, color: Colors.grey),
      const SizedBox(width: 8),
      Expanded(child: Text(text)),
    ],
  );

  Widget _input(TextEditingController c, String label,
      {int maxLines = 1}) =>
      TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
}
