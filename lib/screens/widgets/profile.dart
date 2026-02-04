import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/controllers/home_controller.dart';
import 'package:new_app/controllers/profile_image_controller.dart';
import 'package:new_app/routes/app_routes.dart';

class ProfileDropdownTile extends StatefulWidget {
  
  const ProfileDropdownTile({Key? key}) : super(key: key);

  @override
  State<ProfileDropdownTile> createState() => _ProfileDropdownTileState();
}

class _ProfileDropdownTileState extends State<ProfileDropdownTile>
    with SingleTickerProviderStateMixin {

  Future<void> performLogout() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    // 🔥 CLEAR & DELETE CONTROLLERS
    final auth = Get.find<AuthenticationController>();
    auth.logout();
    Get.find<ProfileImageController>().clear();


    Get.delete<ProfileImageController>(force: true);
    Get.delete<HomeController>(force: true);

    // 🚀 Go to HOME cleanly
    Get.offAllNamed(AppRoutes.home);

    Get.snackbar(
      "Logout",
      "Successfully logged out",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  bool isExpanded = false;


  late final AnimationController _controller;
  late final Animation<double> _arrowRotation;
  late final Animation<double> _expandAnimation;
  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _arrowRotation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
    _expandAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void toggleDropdown() {
    setState(() {
      isExpanded = !isExpanded;
      isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  Widget _buildSubItem({
    required IconData icon,
    required String title,
    required String route,
    VoidCallback? onTap,
  }) {
    
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 72, right: 16),
      leading: Icon(icon, size: 20),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      onTap: onTap ?? () {
        Get.toNamed(route);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthenticationController>();
    return Obx((){
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // MAIN TILE
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(
            auth.username ?? "Guest",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: RotationTransition(
            turns: _arrowRotation,
            child: const Icon(Icons.keyboard_arrow_down),
          ),
          onTap: toggleDropdown,
        ),

        // DROPDOWN (FIXED)
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
                if(auth.role=='vendor')...[
                _buildSubItem(
                  icon: Icons.inbox_outlined,
                  title: "Add Listings",
                  route: "/addlistings",
                ),
                _buildSubItem(
                  icon: Icons.inbox_outlined,
                  title: "My Listings",
                  route: "/mylisting",
                ),
                _buildSubItem(
                icon: Icons.inbox_outlined,
                title: "My Inquiries",
                route: "/inquirie",
                ),
                ],
                _buildSubItem(
                  icon: Icons.inbox_outlined,
                  title: "My Inbox",
                  route: "/myinbox",
                ),
                _buildSubItem(
                  icon: Icons.lightbulb_outline,
                  title: "My Ideas",
                  route: "/myideas",
                ),
                _buildSubItem(
                  icon: Icons.add_circle_outline,
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
