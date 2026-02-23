import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class ReviewToVendor extends StatefulWidget {
  final String ownerId;
  final String listingId;
  const ReviewToVendor({
    Key? key,
    required this.ownerId,
    required this.listingId,
  }) : super(key: key);

  @override
  State<ReviewToVendor> createState() => _ReviewToVendorState();
}

class _ReviewToVendorState extends State<ReviewToVendor> {
  final AuthenticationController auth = Get.find<AuthenticationController>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController reviewCtrl = TextEditingController();

  int rating = 0;

  Future<void> submitReview() async {
    try {
      print("Name: ${nameCtrl.text}");
      print("Email: ${emailCtrl.text}");
      print("Phone: ${phoneCtrl.text}");
      print("Rating: $rating");
      print("Review: ${reviewCtrl.text}");
      if (nameCtrl.text.trim().isEmpty) {
        CustomSnackbar.showError("Please enter your name");
        return;
      }

      if (emailCtrl.text.trim().isEmpty) {
        CustomSnackbar.showError("Please enter your email");
        return;
      }

      // simple email regex
      if (!GetUtils.isEmail(emailCtrl.text.trim())) {
        CustomSnackbar.showError("Please enter a valid email");
        return;
      }

      if (phoneCtrl.text.trim().isEmpty) {
        CustomSnackbar.showError("Please enter your phone number");
        return;
      }

      if (phoneCtrl.text.trim().length < 10) {
        CustomSnackbar.showError("Please enter valid phone number");
        return;
      }

      if (rating == 0) {
        CustomSnackbar.showError("Please give a rating");
        return;
      }

      if (reviewCtrl.text.trim().isEmpty) {
        CustomSnackbar.showError("Please write a review");
        return;
      }

      if (auth.userId == null || auth.userId!.isEmpty) {
        CustomSnackbar.showError("User not logged in");
        return;
      }
      final response = await ProfileService().addReviewFun(
        vendorId: widget.ownerId,
        listingId: widget.listingId,
        rating: rating.toString(),
        review: reviewCtrl.text,
        name: nameCtrl.text,
        email: emailCtrl.text,
        phone: phoneCtrl.text,
        userId: auth.userId ?? '',
      );

      if (response['status'] == 'success') {
        CustomSnackbar.showSuccess("Review submitted successfully");

        // Optional: clear fields
        nameCtrl.clear();
        emailCtrl.clear();
        phoneCtrl.clear();
        reviewCtrl.clear();
        rating = 0;
      } else {
        CustomSnackbar.showError(response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    }
  }

  Widget _star(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          rating = index + 1;
        });
      },
      child: Icon(
        Icons.star,
        size: 28,
        color: index < rating ? Colors.amber : Colors.grey.shade400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Review To Vendor",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _input(nameCtrl, "Your Name"),
          const SizedBox(height: 12),

          _input(emailCtrl, "Your Email"),
          const SizedBox(height: 12),

          _input(phoneCtrl, "Your Phone"),
          const SizedBox(height: 16),

          const Text(
            "Your Rating",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Row(children: List.generate(5, (index) => _star(index))),

          const SizedBox(height: 16),

          _input(reviewCtrl, "Leave your review here", maxLines: 4),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: submitReview,
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text(
                "Submit Review",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFc71f37),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),

        // Normal Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),

        // Focused Border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),

        // Error Border (optional)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
