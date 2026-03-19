import 'package:get/get.dart';

import '../core/storage/local_storage.dart';
import '../data/services/authentication_service.dart';

class AuthenticationController extends GetxController {
  final AuthenticationService _service = AuthenticationService();
  final LocalStorage _storage = LocalStorage();
  // observable state
  final isLoading = false.obs;
  final userData = Rxn<Map<String, dynamic>>();
  final error = ''.obs;

  // ✅ AUTO LOAD ON APP START
  @override
  void onInit() {
    super.onInit();

    final storedUser = _storage.getUser();

    if (storedUser != null) {
      userData.value = storedUser;
    } else {
      userData.value = null; // expired → logout state
    }
  }

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
        _storage.saveUser(user);
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
    _storage.clearUser();
  }

  void refreshSession() {
    final user = userData.value;
    if (user != null) {
      _storage.saveUser(user); // reset 30 min
    }
  }

  // getters for global access
  String? get userId => userData.value?['user_id']?.toString();
  String? get username => userData.value?['username'];
  String? get email => userData.value?['email'];
  String? get role => userData.value?['role'];
}
