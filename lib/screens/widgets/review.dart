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

  bool nameError = false;
  bool emailError = false;
  bool phoneError = false;
  bool reviewError = false;
  bool ratingError = false;
  bool isloading = false;
  Future<void> submitReview() async {
    if(isloading)return;
    setState(() {
      nameError = nameCtrl.text.trim().isEmpty;
      emailError =
          emailCtrl.text.trim().isEmpty ||
          !GetUtils.isEmail(emailCtrl.text.trim());
      phoneError =
          phoneCtrl.text.trim().isEmpty || phoneCtrl.text.trim().length < 10;
      reviewError = reviewCtrl.text.trim().isEmpty;
      ratingError = rating == 0;
    });

    if (nameError || emailError || phoneError || reviewError || ratingError) {
      CustomSnackbar.showError("All fields are required");
      return;
    }

    if (auth.userId == null || auth.userId!.isEmpty) {
      CustomSnackbar.showError("User not logged in");
      return;
    }
    setState(() {
      isloading=true;
    });
    try {
      final response = await ProfileService().addReviewFun(
        vendorId: widget.ownerId,
        listingId: widget.listingId,
        rating: rating.toString(),
        review: reviewCtrl.text.trim(),
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        userId: auth.userId ?? '',
      );

      if (response['status'] == 'success') {
        CustomSnackbar.showSuccess("Review submitted successfully");

        nameCtrl.clear();
        emailCtrl.clear();
        phoneCtrl.clear();
        reviewCtrl.clear();

        setState(() {
          rating = 0;
        });
      } else {
        CustomSnackbar.showError(response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    }finally {
      if (mounted) {
        setState(() {
          isloading = false;   // STOP LOADING
        });
      }
    }
  }

  Widget _star(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          rating = index + 1;
          ratingError = false;
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

          _input(
            nameCtrl,
            "Your Name",
            nameError,
            errorText: "Please enter your name",
          ),
          const SizedBox(height: 12),

          _input(
            emailCtrl,
            "Your Email",
            emailError,
            errorText: "Please enter valid email",
          ),
          const SizedBox(height: 12),

          _input(
            phoneCtrl,
            "Your Phone",
            phoneError,
            errorText: "Please enter valid phone number",
          ),
          const SizedBox(height: 16),

          const Text(
            "Your Rating",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Row(children: List.generate(5, (index) => _star(index))),

          if (ratingError)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Please give a rating",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          const SizedBox(height: 16),

          _input(
            reviewCtrl,
            "Leave your review here",
            reviewError,
            maxLines: 4,
            errorText: "Please write a review",
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed:isloading ? null: submitReview,
              icon: const Icon(Icons.send, color: Colors.white),
              label: isloading
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ) : const Text(
                "Submit Review",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFc71f37),
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
    String hint,
    bool hasError, {
    int maxLines = 1,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          onChanged: (_) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black),

            suffixIcon: hasError
                ? const Icon(Icons.error_outline, color: Colors.red)
                : null,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.black,
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.black,
                width: 1,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorText ?? "",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
