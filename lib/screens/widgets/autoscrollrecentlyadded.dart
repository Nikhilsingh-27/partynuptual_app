import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/listing_card.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:get/get.dart';

class AutoScrollCards extends StatefulWidget {
  const AutoScrollCards({super.key});

  @override
  State<AutoScrollCards> createState() => _AutoScrollCardsState();
}

class _AutoScrollCardsState extends State<AutoScrollCards> {
  final HomeController controller = Get.find();

  final PageController _pageController =
  PageController(viewportFraction: 0.8);

  Timer? _timer;
  int _currentPage = 0;
  bool _isTimerRunning = false;

  String getLogoImageUrl(String? logoImage) {
    const baseUrl =
        "https://partynuptual.com/public/uploads/logo/";
    const fallback =
        "https://partynuptual.com/public/front/assets/img/list-8.jpg";

    if (logoImage == null || logoImage.isEmpty) return fallback;

    if (logoImage.contains("upload/logo/")) {
      return baseUrl + logoImage.replaceFirst("upload/logo/", "");
    }

    return baseUrl + logoImage;
  }

  void _startAutoScroll(int itemCount) {
    if (_isTimerRunning || itemCount <= 1) return;

    _isTimerRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients) return;

      _currentPage = (_currentPage + 1) % itemCount;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
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

      final listings = homeData.data["data"]["listings"] as List;

      _startAutoScroll(listings.length);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 340,
          child: PageView.builder(
            controller: _pageController,
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final item = listings[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: buildListingCard(
                  context: context,
                  listingid: item["listing_id"],
                  image: getLogoImageUrl(item['logo_image']),
                  name: item['company_name'] ?? '',
                  description: item['about'] ?? '',
                  phone: item['phone_number'] ?? '',
                  location: item['office_address'] ?? '',
                  ownerid: item['owner_id']??''
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
