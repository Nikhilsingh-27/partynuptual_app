import 'package:get/get.dart';
import 'package:new_app/data/services/profile_service.dart';

class InboxController extends GetxController {
  var totalUnread = 0.obs;
  var totalInquiryUnread = 0.obs;
  Future<void> fetchInbox(String userId) async {
    try {
      final response = await ProfileService().getConversations(userId: userId);

      if (response["status"] == true) {
        final data = List<Map<String, dynamic>>.from(response["data"]);

        int total = data.fold(
          0,
          (sum, item) =>
              sum +
              (int.tryParse(item["unread_count"]?.toString() ?? "0") ?? 0),
        );

        totalUnread.value = total;
      } else {
        totalUnread.value = 0;
      }
    } catch (_) {
      totalUnread.value = 0;
    }
  }

  Future<void> fetchInquiries(String vendorId) async {
    try {
      final response = await ProfileService().getinquiry(id: vendorId);

      if (response["status"] == "success") {
        final data = List<Map<String, dynamic>>.from(response["data"]);

        int total = data.fold(
          0,
          (sum, item) =>
              sum + ((item["email_status"]?.toString() == "0") ? 1 : 0),
        );

        totalInquiryUnread.value = total;
      } else {
        totalInquiryUnread.value = 0;
      }
    } catch (e) {
      totalInquiryUnread.value = 0;
    }
  }
}
