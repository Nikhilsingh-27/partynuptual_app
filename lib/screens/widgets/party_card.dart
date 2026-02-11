import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
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

    // Optimistic UI update
    setState(() {
      if (!isLiked) {
        likeCount++;
        isLiked = true;
        // Remove dislike if it was selected
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
    } catch (e) {
      // Revert if API fails
      setState(() {
        likeCount--;
        isLiked = false;
        if (isDisliked == false) {
          dislikeCount++;
          isDisliked = true;
        }
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

    // Optimistic UI update
    setState(() {
      if (!isDisliked) {
        dislikeCount++;
        isDisliked = true;
        // Remove like if it was selected
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
    } catch (e) {
      // Revert if API fails
      setState(() {
        dislikeCount--;
        isDisliked = false;
        if (isLiked == false) {
          likeCount++;
          isLiked = true;
        }
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
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              "https://partynuptual.com/public/uploads/ideas/${widget.image}",
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    widget.title,
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
                          widget.location,
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
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),

                  const Spacer(),

                  /// DATE + LIKE/DISLIKE
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          /// LIKE
                          IconButton(
                            icon: Icon(
                              Icons.thumb_up_outlined,
                              size: 18,
                              color: isLiked
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: onLikePressed,
                          ),
                          Text(
                            likeCount.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600]),
                          ),

                          const SizedBox(width: 10),

                          /// DISLIKE
                          IconButton(
                            icon: Icon(
                              Icons.thumb_down_outlined,
                              size: 18,
                              color: isDisliked
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: onDislikePressed,
                          ),
                          Text(
                            dislikeCount.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600]),
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
}
