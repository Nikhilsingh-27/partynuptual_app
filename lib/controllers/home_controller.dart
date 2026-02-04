import 'package:get/get.dart';
import '../data/models/home_model.dart';
import '../data/services/home_service.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService();

  // Observable variables
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

  void clear() {
    isLoading.value = false;
    homeData.value = null;
    error.value = '';
  }
}
