import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/data/services/profile_service.dart';

class PartyCard extends StatefulWidget {
  final String id;
  final String image;
  final String title;
  final String location;
  final String description;
  final String date;
  final int likes;
  final int dislikes;

  const PartyCard({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.location,
    required this.description,
    required this.date,
    required this.likes,
    required this.dislikes,
  });

  @override
  State<PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard> {
  final HomeController homeController = Get.find();
  final AuthenticationController authController = Get.find();
  late int likeCount;
  late int dislikeCount;
  bool isLiked = false;
  bool isDisliked = false;
  bool isLoadingReaction = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
    dislikeCount = widget.dislikes;
  }

  Future<void> onLikePressed() async {
    if (isLoadingReaction) return;

    final auth = Get.find<AuthenticationController>();

    if (auth.userId == null || auth.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    setState(() => isLoadingReaction = true);

    try {
      final response = await ProfileService().likedislikefun(
        user_id: auth.userId!,
        idea_id: widget.id,
        action: "like",
      );

      if (response["status"] == "success") {
        setState(() {
          likeCount =
              int.tryParse(response["like_count"].toString()) ?? likeCount;
          dislikeCount =
              int.tryParse(response["dislike_count"].toString()) ??
              dislikeCount;
          homeController.updateIdeaReaction(
            ideaId: widget.id,
            newLike: likeCount,
            newDislike: dislikeCount,
          );
          isLiked = true; // 🔥 turn red
          isDisliked = false;
          // 🔥 remove other
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to like this item');
    }

    setState(() => isLoadingReaction = false);
  }

  Future<void> onDislikePressed() async {
    if (isLoadingReaction) return;

    final auth = Get.find<AuthenticationController>();

    if (auth.userId == null || auth.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    setState(() => isLoadingReaction = true);

    try {
      final response = await ProfileService().likedislikefun(
        user_id: auth.userId!,
        idea_id: widget.id,
        action: "dislike",
      );

      if (response["status"] == "success") {
        setState(() {
          likeCount =
              int.tryParse(response["like_count"].toString()) ?? likeCount;
          dislikeCount =
              int.tryParse(response["dislike_count"].toString()) ??
              dislikeCount;

          homeController.updateIdeaReaction(
            ideaId: widget.id,
            newLike: likeCount,
            newDislike: dislikeCount,
          );
          isDisliked = true; // 🔥 turn red
          isLiked = false;
          // 🔥 remove other
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to dislike this item');
    }

    setState(() => isLoadingReaction = false);
  }

  @override
  Widget build(BuildContext context) {
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
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                "https://partynuptual.com/public/uploads/ideas/${widget.image}",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// BODY
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP CONTENT (WITH PADDING)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      /// LOCATION
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// DESCRIPTION
                      Text(
                        widget.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, height: 1.2),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// 🔥 FULL WIDTH DIVIDER
                Divider(
                  thickness: 0.8,
                  height: 1,
                  color: Colors.black.withOpacity(0.07),
                ),

                /// BOTTOM ROW (WITH PADDING)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      /// DATE
                      Expanded(
                        child: Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      /// LIKE / DISLIKE
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: onLikePressed,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_outlined,
                                  size: 16,
                                  color: isLiked ? Colors.red : Colors.black,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  likeCount.toString(),
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: onDislikePressed,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_down_outlined,
                                  size: 16,
                                  color: isDisliked ? Colors.red : Colors.black,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  dislikeCount.toString(),
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
