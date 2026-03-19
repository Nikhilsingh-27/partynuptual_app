import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final box = GetStorage();

  static const _userKey = "user";
  static const _expiryKey = "expiry";
  static const _ageConfirmedKey = "ageConfirmedAt";

  // ✅ Save user + expiry
  void saveUser(Map<String, dynamic> user) {
    box.write(_userKey, user);

    final expiry = DateTime.now().add(const Duration(minutes: 30));
    box.write(_expiryKey, expiry.toIso8601String());
  }

  // ✅ Get user (with expiry check)
  Map<String, dynamic>? getUser() {
    final user = box.read(_userKey);
    final expiryString = box.read(_expiryKey);

    if (user == null || expiryString == null) return null;

    final expiry = DateTime.tryParse(expiryString);
    if (expiry == null) return null;

    // ❌ अगर expire हो गया → clear
    if (DateTime.now().isAfter(expiry)) {
      clearUser();
      return null;
    }

    return Map<String, dynamic>.from(user);
  }

  // ✅ Clear all
  void clearUser() {
    box.remove(_userKey);
    box.remove(_expiryKey);
  }

  // ✅ Age confirmation (shown once + every 30 days)
  bool get isAgeConfirmed {
    final stored = box.read(_ageConfirmedKey);
    if (stored == null) return false;

    final confirmedAt = DateTime.tryParse(stored);
    if (confirmedAt == null) return false;

    return DateTime.now().difference(confirmedAt) < const Duration(days: 30);
  }

  void confirmAge() {
    box.write(_ageConfirmedKey, DateTime.now().toIso8601String());
  }
}
