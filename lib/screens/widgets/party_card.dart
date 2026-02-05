import 'package:flutter/material.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:new_app/data/services/profile_service.dart';
Widget buildPartyCard({
  required String id,
  required String image,
  required String title,
  required String location,
  required String description,
  required String date,
  required int likes,
  required int dislikes,
}) {
  void onLikePressed(String ideaId) async {
    final AuthenticationController auth =
    Get.find<AuthenticationController>();

    // ❌ User not logged in
    if (auth.userId == null || auth.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    // ✅ User logged in → call API
    try {
      final response = await ProfileService().likedislikefun(
        user_id: auth.userId!,
        idea_id: ideaId,
        action: "like",
      );

      if (response['status'] == true ||
          response['status'] == "success") {
        Get.snackbar(
          "Success",
          "Liked successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  void onDislikePressed(String ideaId) async {
    final AuthenticationController auth =
    Get.find<AuthenticationController>();

    // ❌ User not logged in
    if (auth.userId == null || auth.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    // ✅ User logged in → call API
    try {
      final response = await ProfileService().likedislikefun(
        user_id: auth.userId!,
        idea_id: ideaId,
        action: "dislike",
      );

      if (response['status'] == true ||
          response['status'] == "success") {
        Get.snackbar(
          "Success",
          "Dislike successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final AuthenticationController auth = Get.find<AuthenticationController>();
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 IMAGE (same proportion as listing card)
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            "https://partynuptual.com/public/uploads/ideas/${image}",
            height: 160, // ✅ IMPORTANT: matches listing card feel
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        /// 🔹 CONTENT
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                /// LOCATION
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// DESCRIPTION
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),

                const Spacer(),

                /// DATE + LIKES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.thumb_up_outlined,
                            size: 15,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            onLikePressed(id);
                          },
                        ),

                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.thumb_up_outlined,
                            size: 15,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            onLikePressed(id);
                          },
                        ),
                        const SizedBox(width: 4),
                        Text(
                          likes.toString(),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(
                            Icons.thumb_down_outlined,
                            size: 15,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            onDislikePressed(id);
                          },
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dislikes.toString(),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
