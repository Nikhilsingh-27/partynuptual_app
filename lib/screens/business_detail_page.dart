import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/home_service.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/bottom.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';
import 'package:new_app/screens/widgets/review.dart';
import 'package:new_app/screens/widgets/vendordesc.dart';

class BusinessDetailPage extends StatefulWidget {
  final String listingid;
  final String ownerid;
  const BusinessDetailPage({
    super.key,
    required this.listingid,
    required this.ownerid,
  });

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  // 🔴 Inquiry Form Errors
  bool showNameError = false;
  bool showEmailError = false;
  bool showPhoneError = false;
  bool showCommentError = false;
  bool showEmailFormatError = false;
  bool showPhoneLengthError = false;
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController commentCtrl = TextEditingController();

  final AuthenticationController auth = Get.find<AuthenticationController>();

  bool isloading = true;

  List<String> videoThumbs = [];

  Map<String, dynamic> listing = {};
  List gallerylist = [];
  Future<void> fetchlistingbyid(String id) async {
    final response = await HomeService().getlistingbyid(id: id);
    final gallerydata = await HomeService().gallerybyid(id: id);

    setState(() {
      listing = response["data"] ?? {};
      gallerylist = gallerydata["data"] ?? [];

      String? videosString = listing["videos"];

      if (videosString != null && videosString.isNotEmpty) {
        videoThumbs = videosString
            .split(",") // split by comma
            .map((e) => e.trim()) // remove extra spaces
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        videoThumbs = [];
      }

      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    //print(widget.listingid);
    fetchlistingbyid(widget.listingid);
  }

  bool inquirycheck=false;
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
      body: isloading
          ? Center(child: const CircularProgressIndicator())
          : SingleChildScrollView(
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
                                  listing["company_name"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        listing["office_address"] ?? "",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.verified,
                                      color: const Color(0xFF198754),
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Verified Listing",
                                      style: TextStyle(
                                        color: const Color(0xFF198754),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        if (auth.userId == null ||
                                            auth.userId!.isEmpty) {
                                          Get.toNamed('/vsignin');
                                          return;
                                        }
                                        final response = await ProfileService()
                                            .startconversationfun(
                                              user_id:
                                                  auth.userId ??
                                                  "", // 🔥 replace with actual user id
                                              vendor_id: widget
                                                  .ownerid, // 🔥 replace with actual vendor id
                                            );

                                        print(
                                          "Start Conversation Response: $response",
                                        );

                                        if (response["status"] == true) {
                                          Get.toNamed("/myinbox");
                                        } else {
                                          CustomSnackbar.showError(
                                            response["message"] ??
                                                "Failed to start conversation",
                                          );
                                        }
                                      } catch (e) {
                                        CustomSnackbar.showError(
                                          "Something went wrong",
                                        );
                                      }
                                    },

                                    icon: const Icon(Icons.chat_bubble_outline),
                                    label: const Text(
                                      "Chat Now",
                                      style: TextStyle(
                                        color: const Color(0xFFC72443),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink.shade50,
                                      foregroundColor: Colors.red,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
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
                          ListingDetailsDropdown(
                            lat: listing["lattitude"] ?? "",
                            long: listing["longnitude"] ?? "",
                            desc: listing["about"] ?? "",
                            gallery: gallerylist,
                            video: videoThumbs,
                          ),
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
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  bottom: 20,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Added By",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      "Vendor",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          /// CONTACT DETAILS
                          _sectionCard(
                            Column(
                              children: [
                                _infoRow(Icons.phone, listing["phone_number"]),
                                const SizedBox(height: 12),
                                _infoRow(
                                  Icons.location_on,
                                  listing["office_address"],
                                ),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                _input(
                                  nameCtrl,
                                  "Your Name",
                                  showError: showNameError,
                                  errorText: "Name is required",
                                  onChanged: (val) {
                                    if (val.trim().isNotEmpty) {
                                      setState(() => showNameError = false);
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),

                                _input(
                                  emailCtrl,
                                  "Your Email",
                                  showError:
                                      showEmailError || showEmailFormatError,
                                  errorText: showEmailFormatError
                                      ? "Enter valid email"
                                      : "Email is required",
                                  onChanged: (val) {
                                    setState(() {
                                      showEmailError = false;
                                      showEmailFormatError = false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),

                                _input(
                                  phoneCtrl,
                                  "Your Phone",
                                  showError:
                                      showPhoneError || showPhoneLengthError,
                                  errorText: showPhoneLengthError
                                      ? "Enter valid phone number"
                                      : "Phone is required",
                                  onChanged: (val) {
                                    setState(() {
                                      showPhoneError = false;
                                      showPhoneLengthError = false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),

                                _input(
                                  commentCtrl,
                                  "Leave a comment",
                                  maxLines: 4,
                                  showError: showCommentError,
                                  errorText: "Message is required",
                                  onChanged: (val) {
                                    if (val.trim().isNotEmpty) {
                                      setState(() => showCommentError = false);
                                    }
                                  },
                                ),

                                const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: inquirycheck ? null : () async {

                                    if (inquirycheck) return;

                                    setState(() {
                                      showNameError = nameCtrl.text.trim().isEmpty;
                                      showEmailError = emailCtrl.text.trim().isEmpty;
                                      showEmailFormatError =
                                          emailCtrl.text.isNotEmpty &&
                                              !GetUtils.isEmail(emailCtrl.text.trim());

                                      showPhoneError = phoneCtrl.text.trim().isEmpty;
                                      showPhoneLengthError =
                                          phoneCtrl.text.isNotEmpty &&
                                              phoneCtrl.text.trim().length < 6;

                                      showCommentError = commentCtrl.text.trim().isEmpty;
                                    });

                                    if (showNameError ||
                                        showEmailError ||
                                        showEmailFormatError ||
                                        showPhoneError ||
                                        showPhoneLengthError ||
                                        showCommentError) {
                                      CustomSnackbar.showError("All fields are required");
                                      return;
                                    }

                                    setState(() {
                                      inquirycheck = true;
                                    });

                                    try {

                                      final response = await ProfileService().sendinquiry(
                                        name: nameCtrl.text.trim(),
                                        email: emailCtrl.text.trim(),
                                        phone: phoneCtrl.text.trim(),
                                        message: commentCtrl.text.trim(),
                                        listing_id: widget.listingid,
                                        vendor_id: widget.ownerid,
                                      );

                                      final bool isSuccess =
                                          response["status"] == true ||
                                              response["status"] == "success";

                                      if (isSuccess) {
                                        CustomSnackbar.showSuccess("Inquiry sent successfully");

                                        nameCtrl.clear();
                                        emailCtrl.clear();
                                        phoneCtrl.clear();
                                        commentCtrl.clear();
                                      } else {
                                        CustomSnackbar.showError(
                                            response["message"] ?? "Failed to send inquiry");
                                      }

                                    } catch (e) {
                                      CustomSnackbar.showError("Something went wrong");
                                    }

                                    if (mounted) {
                                      setState(() {
                                        inquirycheck = false;
                                      });
                                    }

                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFc71f37),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),

                                  child: inquirycheck
                                      ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        "Send Inquiry",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (auth.role == 'vendor' || auth.role == 'guest')
                            ReviewToVendor(
                              ownerId: widget.ownerid,
                              listingId: widget.listingid,
                            ),
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
      Icon(icon, size: 18, color: Colors.black),
      const SizedBox(width: 8),
      Expanded(child: Text(text)),
    ],
  );

  Widget _input(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool showError = false,
    String? errorText,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            labelText: label,

            suffixIcon: showError
                ? const Icon(Icons.error_outline, color: Colors.red)
                : null,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: showError ? Colors.red : Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: showError ? Colors.red : Colors.black,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (showError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
