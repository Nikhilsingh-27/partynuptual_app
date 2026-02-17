import 'package:get/get.dart';

import '../data/services/authentication_service.dart';

class AuthenticationController extends GetxController {
  final AuthenticationService _service = AuthenticationService();

  // observable state
  final isLoading = false.obs;
  final userData = Rxn<Map<String, dynamic>>();
  final error = ''.obs;
  Future<Map<String, dynamic>> login({
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

      if (response["status"] == true) {
        final user = Map<String, dynamic>.from(response['data']);
        user['role'] = role;
        userData.value = user;
      }
      print(response);
      return response; // ✅ RETURN RESPONSE
    } catch (e) {
      error.value = e.toString();
      return {"status": false, "message": e.toString()};
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
