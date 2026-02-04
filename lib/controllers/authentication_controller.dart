import 'package:get/get.dart';
import '../data/services/authentication_service.dart';

class AuthenticationController extends GetxController {
  final AuthenticationService _service = AuthenticationService();

  // observable state
  final isLoading = false.obs;
  final userData = Rxn<Map<String, dynamic>>();
  final error = ''.obs;

  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _service.loginfun(
        email: email,
        password: password,
        role: role,
      );
    final user = Map<String, dynamic>.from(response['data']);
    user['role'] = role; // ✅ add role manually

    userData.value = user;
    print(userData.value);
    print(userData.value?['user_id']);// adjust based on API structure
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    // reset observables
    userData.value = null;
    error.value = '';
    isLoading.value = false;
  }
  // getters for global access
  String? get userId => userData.value?['user_id']?.toString();
  String? get username => userData.value?['username'];
  String? get email => userData.value?['email'];
  String? get role => userData.value?['role'];
}
