import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';

class PartyCardScroll extends StatefulWidget {
  final String id;
  final String image;
  final String title;
  final String location;
  final String description;
  final String date;
  final int likes;
  final int dislikes;

  const PartyCardScroll({
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
  State<PartyCardScroll> createState() => _PartyCardScrollState();
}

class _PartyCardScrollState extends State<PartyCardScroll> {
  late int likeCount;
  late int dislikeCount;
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
    dislikeCount = widget.dislikes;
  }

  Future<void> onLikePressed() async {
    final auth = Get.find<AuthenticationController>();

    if (auth.userId == null || auth.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    setState(() {
      if (!isLiked) {
        likeCount++;
        isLiked = true;
        if (isDisliked) {
          dislikeCount--;
          isDisliked = false;
        }
      }
    });

    try {
      await ProfileService().likedislikefun(
        user_id: auth.userId!,
        idea_id: widget.id,
        action: "like",
      );
    } catch (_) {
      setState(() {
        likeCount--;
        isLiked = false;
      });
      Get.snackbar('Error', 'Failed to like this item');
    }
  }

  Future<void> onDislikePressed() async {
    final auth = Get.find<AuthenticationController>();

    if (auth.userId == null || auth.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    setState(() {
      if (!isDisliked) {
        dislikeCount++;
        isDisliked = true;
        if (isLiked) {
          likeCount--;
          isLiked = false;
        }
      }
    });

    try {
      await ProfileService().likedislikefun(
        user_id: auth.userId!,
        idea_id: widget.id,
        action: "dislike",
      );
    } catch (_) {
      setState(() {
        dislikeCount--;
        isDisliked = false;
      });
      Get.snackbar('Error', 'Failed to dislike this item');
    }
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
              aspectRatio: 16 / 9,
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
                /// TOP CONTENT WITH PADDING
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      Text(
                        widget.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, height: 1),
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

                /// BOTTOM ROW WITH PADDING
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
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
                                  color: isLiked ? Colors.blue : Colors.grey,
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
                                  color: isDisliked ? Colors.red : Colors.grey,
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
