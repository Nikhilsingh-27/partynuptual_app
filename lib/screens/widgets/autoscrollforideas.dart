import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/screens/widgets/party_card_for_scroll.dart';

class AutoScrollPartyCards extends StatefulWidget {
  const AutoScrollPartyCards({super.key});

  @override
  State<AutoScrollPartyCards> createState() => _AutoScrollPartyCardsState();
}

class _AutoScrollPartyCardsState extends State<AutoScrollPartyCards> {
  final HomeController controller = Get.find();

  final PageController _pageController = PageController(viewportFraction: 0.8);

  Timer? _timer;
  int _currentPage = 0;
  bool _autoScrollStarted = false;

  void _startAutoScroll(int itemCount) {
    if (_autoScrollStarted || itemCount <= 1) return;

    _autoScrollStarted = true;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients) return;

      _currentPage = (_currentPage + 1) % itemCount;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final homeData = controller.homeData.value;

      if (homeData == null) {
        return const SizedBox(
          height: 350,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final ideas = homeData.data["data"]["share_ideas"] as List;

      _startAutoScroll(ideas.length);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: ideas.length,
            itemBuilder: (context, index) {
              final item = ideas[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: PartyCardScroll(
                  id: item['id'],
                  image: item['image'],
                  title: item['party_theme'],
                  location: item['venue'],
                  description: item['description'],
                  date: item['date_added'],
                  likes:
                      int.tryParse(item['like_count']?.toString() ?? '0') ?? 0,
                  dislikes:
                      int.tryParse(item['dislike_count']?.toString() ?? '0') ??
                      0,
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
