import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/data/services/profile_service.dart';

class PartyCardScroll extends StatefulWidget {
  final int index;

  const PartyCardScroll({super.key, required this.index});

  @override
  State<PartyCardScroll> createState() => _PartyCardScrollState();
}

class _PartyCardScrollState extends State<PartyCardScroll>
    with AutomaticKeepAliveClientMixin {
  final HomeController homeController = Get.find();
  final AuthenticationController authController = Get.find();

  bool isLoadingReaction = false;
  String? selectedReaction; // "like", "dislike", or null
  @override
  bool get wantKeepAlive => true;

  Future<void> onLikePressed(String ideaId) async {
    if (isLoadingReaction) return;

    if (authController.userId == null || authController.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    setState(() => isLoadingReaction = true);

    try {
      final response = await ProfileService().likedislikefun(
        user_id: authController.userId!,
        idea_id: ideaId,
        action: "like",
      );

      if (response["status"] == "success") {
        final newLike = int.tryParse(response["like_count"].toString()) ?? 0;
        final newDislike =
            int.tryParse(response["dislike_count"].toString()) ?? 0;

        homeController.updateIdeaReaction(
          ideaId: ideaId,
          newLike: newLike,
          newDislike: newDislike,
        );

        setState(() {
          selectedReaction = selectedReaction == "like"
              ? null
              : "like"; // toggle
        });
        // final homeControll = Get.find<HomeController>();
        //
        // await homeControll.fetchHomeData();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to like');
    }

    setState(() => isLoadingReaction = false);
  }

  Future<void> onDislikePressed(String ideaId) async {
    if (isLoadingReaction) return;

    if (authController.userId == null || authController.userId!.isEmpty) {
      Get.toNamed('/vsignin');
      return;
    }

    setState(() => isLoadingReaction = true);

    try {
      final response = await ProfileService().likedislikefun(
        user_id: authController.userId!,
        idea_id: ideaId,
        action: "dislike",
      );

      if (response["status"] == "success") {
        final newLike = int.tryParse(response["like_count"].toString()) ?? 0;
        final newDislike =
            int.tryParse(response["dislike_count"].toString()) ?? 0;

        homeController.updateIdeaReaction(
          ideaId: ideaId,
          newLike: newLike,
          newDislike: newDislike,
        );

        setState(() {
          selectedReaction = selectedReaction == "dislike"
              ? null
              : "dislike"; // toggle
        });
        // final homeControll = Get.find<HomeController>();
        //
        // await homeControll.fetchHomeData();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to dislike');
    }

    setState(() => isLoadingReaction = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      final ideas =
          homeController.homeData.value?.data["data"]["share_ideas"] as List?;

      if (ideas == null || widget.index >= ideas.length) {
        return const SizedBox();
      }

      final item = ideas[widget.index];

      final likeCount =
          int.tryParse(item['like_count']?.toString() ?? '0') ?? 0;
      final dislikeCount =
          int.tryParse(item['dislike_count']?.toString() ?? '0') ?? 0;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect(
            //   borderRadius: const BorderRadius.vertical(
            //     top: Radius.circular(14),
            //   ),
            //   child: AspectRatio(
            //     aspectRatio: 16 / 9,
            //     child: Image.network(
            //       "https://partynuptual.com/public/uploads/ideas/${item['image']}",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  "https://partynuptual.com/public/uploads/ideas/${item['image']}",
                  fit: BoxFit.fill, // ✅ stretches to fill completely
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['party_theme'] ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['venue'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['description'] ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Divider(
                    thickness: 0.8,
                    height: 1,
                    color: Colors.black.withOpacity(0.07),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['date_added'] ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onLikePressed(item['id'].toString()),
                          child: Row(
                            children: [
                              Icon(
                                Icons.thumb_up_outlined,
                                size: 16,
                                color: selectedReaction == "like"
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                likeCount.toString(),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () => onDislikePressed(item['id'].toString()),
                          child: Row(
                            children: [
                              Icon(
                                Icons.thumb_down_outlined,
                                size: 16,
                                color: selectedReaction == "dislike"
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dislikeCount.toString(),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
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
    });
  }
}
