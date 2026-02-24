import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/count.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/controllers/profile_image_controller.dart';
import 'package:new_app/routes/app_routes.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class ProfileDropdownTile extends StatefulWidget {
  const ProfileDropdownTile({Key? key}) : super(key: key);

  @override
  State<ProfileDropdownTile> createState() => _ProfileDropdownTileState();
}

class _ProfileDropdownTileState extends State<ProfileDropdownTile>
    with SingleTickerProviderStateMixin {
  final auth = Get.find<AuthenticationController>();
  final inbox = Get.find<InboxController>();

  bool isExpanded = false;

  late final AnimationController _controller;
  late final Animation<double> _arrowRotation;
  late final Animation<double> _expandAnimation;
  void _refreshHomePage() {
    final auth = Get.find<AuthenticationController>();

    if (auth.userId != null) {
      inbox.fetchInbox(auth.userId!); // ✅ use existing instance
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _arrowRotation = Tween<double>(begin: 0, end: 0.5).animate(_controller);

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void toggleDropdown() {
    setState(() {
      isExpanded = !isExpanded;
      isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  Future<void> performLogout() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    auth.logout();
    Get.find<ProfileImageController>().clear();

    Get.delete<ProfileImageController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<InboxController>(force: true);

    Get.offAllNamed(AppRoutes.home);

    CustomSnackbar.showSuccess("Logout\nSuccessfully logged out");
  }

  Widget _buildSubItem({
    required IconData icon,
    required String title,
    required String route,
    VoidCallback? onTap,
    int badgeCount = 0,
    bool showBadge = false, // 👈 NEW
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 72, right: 16),
      leading: Icon(icon, size: 20, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: showBadge
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
              child: Text(
                badgeCount.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null, // 👈 only show when true
      onTap: onTap ?? () => Get.toNamed(route),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MAIN TILE
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.black),
            title: Text(
              auth.username ?? "Guest",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            trailing: RotationTransition(
              turns: _arrowRotation,
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ),
            onTap: toggleDropdown,
          ),

          // DROPDOWN
          ClipRect(
            child: SizeTransition(
              sizeFactor: _expandAnimation,
              axisAlignment: -1,
              child: Column(
                children: [
                  _buildSubItem(
                    icon: Icons.person,
                    title: "My Profile",
                    route: "/myprofile",
                  ),

                  if (auth.role == 'vendor') ...[
                    _buildSubItem(
                      icon: Icons.speed_outlined,
                      title: "Add Listings",
                      route: "/addlistings",
                    ),
                    _buildSubItem(
                      icon: Icons.speed_outlined,
                      title: "My Listings",
                      route: "/mylisting",
                    ),
                    _buildSubItem(
                      icon: Icons.speed_outlined,
                      title: "My Inquiries",
                      route: "/inquirie",
                      badgeCount: 0, // change if different
                      showBadge: true,
                    ),
                  ],

                  _buildSubItem(
                    icon: Icons.speed_outlined,
                    title: "My Inbox",
                    route: "",
                    badgeCount: inbox.totalUnread.value,
                    showBadge: true,
                    onTap: () async {
                      await Get.toNamed("/myinbox");
                      _refreshHomePage();
                    },
                  ),

                  _buildSubItem(
                    icon: Icons.speed_outlined,
                    title: "My Ideas",
                    route: "/myideas",
                  ),
                  _buildSubItem(
                    icon: Icons.speed_outlined,
                    title: "Add My Ideas",
                    route: "/addmyideas",
                  ),

                  _buildSubItem(
                    icon: Icons.logout,
                    title: "Logout",
                    route: "",
                    onTap: () async {
                      await performLogout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
