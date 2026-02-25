import 'package:get/get.dart';

import '../data/models/home_model.dart';
import '../data/services/home_service.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService();

  final isLoading = false.obs;
  final homeData = Rxn<HomeModel>();
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _homeService.fetchHomeData();
      homeData.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔥 UPDATE LIKE/DISLIKE COUNT INSIDE CONTROLLER
  void updateIdeaReaction({
    required String ideaId,
    required int newLike,
    required int newDislike,
  }) {
    if (homeData.value == null) return;

    final ideas = homeData.value!.data["data"]["share_ideas"] as List;

    final index = ideas.indexWhere((e) => e['id'] == ideaId);

    if (index != -1) {
      ideas[index] = {
        ...ideas[index],
        "like_count": newLike.toString(),
        "dislike_count": newDislike.toString(),
      };

      homeData.refresh(); // 🔥 VERY IMPORTANT
    }
  }

  /// 🔥 LOCAL INCREMENT (optional for instant UI update)
  void increaseLike(String ideaId) {
    final ideas = homeData.value!.data["data"]["share_ideas"] as List;

    final index = ideas.indexWhere((e) => e['id'] == ideaId);

    if (index != -1) {
      int current = int.tryParse(ideas[index]['like_count'].toString()) ?? 0;

      ideas[index]['like_count'] = (current + 1).toString();
      homeData.refresh();
    }
  }

  void increaseDislike(String ideaId) {
    final ideas = homeData.value!.data["data"]["share_ideas"] as List;

    final index = ideas.indexWhere((e) => e['id'] == ideaId);

    if (index != -1) {
      int current = int.tryParse(ideas[index]['dislike_count'].toString()) ?? 0;

      ideas[index]['dislike_count'] = (current + 1).toString();
      homeData.refresh();
    }
  }

  void clear() {
    isLoading.value = false;
    homeData.value = null;
    error.value = '';
  }
}
