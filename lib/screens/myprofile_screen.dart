import 'package:flutter/material.dart';
import 'package:new_app/controllers/authentication_controller.dart';
import 'package:new_app/data/services/profile_service.dart';
import 'package:new_app/screens/widgets/profileimg/imgupload.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  final AuthenticationController auth = Get.find<AuthenticationController>();


  // Controllers
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController zipCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  final TextEditingController oldPasswordCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();

  String? selectedGender;

  final List<String> genderList = ["Male", "Female", "Other"];
  Future<void> fetchuserdetails() async {
    try {
      final response =
      await ProfileService().getuserdetailsfun(id: auth.userId ?? "");

      if (response == null || response["data"] == null) return;

      final Map<String, dynamic> data = response["data"];

      setState(() {
        firstNameCtrl.text = data["name"] ?? "";
        lastNameCtrl.text = data["last_name"] ?? "";
        addressCtrl.text = data["address"] ?? "";
        zipCtrl.text = data["zip_code"] ?? "";
        emailCtrl.text = data["email"] ?? "";
        phoneCtrl.text = data["phone"] ?? "";
        selectedGender = data["gender"]; // optional
      });

      debugPrint("User details fetched: $data");
    } catch (e) {
      debugPrint("Error fetching user details: $e");
    }
  }

  @override
  void initState(){
    super.initState();
    fetchuserdetails();
  }
  @override
  Widget build(BuildContext context) {
    // print(auth.userId);
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _sectionCard(
              title: "Basic Information",
              child: Column(
                children: [
                  _input("First Name", firstNameCtrl),
                  _input("Last Name", lastNameCtrl),
                  _dropdown(),
                  _input("Address", addressCtrl, maxLines: 3),
                  _input("Zip / Postal Code", zipCtrl),
                  _input("Email", emailCtrl, keyboard: TextInputType.emailAddress),
                  _input("Phone", phoneCtrl, keyboard: TextInputType.phone),
                  const SizedBox(height: 15),
                  _primaryButton("Update Info", _printBasicInfo),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionCard(
              title: "Change Password",
              child: Column(
                children: [
                  _input("Old Password", oldPasswordCtrl, obscure: true),
                  _input("New Password", newPasswordCtrl, obscure: true),
                  const SizedBox(height: 15),
                  _primaryButton("Update Password", _printPasswordInfo),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionCard(
              title: "Danger Zone",
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      final response = await ProfileService()
                          .deleteAccountfun(id: auth.userId ?? "");

                      if (response["status"]=="success") {
                        // Navigate to home and clear previous routes
                        Get.offAllNamed('/home');

                        // Show success snackbar
                        Get.snackbar(
                          "Success",
                          "Account successfully deleted",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      } else {
                        // Optional: failure snackbar
                        Get.snackbar(
                          "Error",
                          "Failed to delete account",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(199, 31, 55,1),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text("Delete Account",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Container(
              child:  Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ProfileImageUploadContainer()
                  ),
            )
            )

          ],
        ),
      ),
    );
  }

  // ========================= UI HELPERS =========================

  Widget _sectionCard({required String title, required Widget child}) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      ),
    );
  }

  Widget _input(
      String label,
      TextEditingController controller, {
        bool obscure = false,
        int maxLines = 1,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: genderList
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) {
          setState(() => selectedGender = val);
        },
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: Color.fromRGBO(199, 31, 55,1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(text,style: TextStyle(color: Colors.white),),
    );
  }

  // ========================= PRINT FUNCTIONS =========================

  void _printBasicInfo() async {
    final auth = Get.find<AuthenticationController>();

    if (auth.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not logged in"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await ProfileService().updateInfo(
        userId: auth.userId!,
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        gender: selectedGender ?? "",
        address: addressCtrl.text.trim(),
        zipCode: zipCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone : phoneCtrl.text.trim(),
      );

      final bool isSuccess =
          response['status'] == true || response['status'] == "success";

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Update failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _printPasswordInfo() async {
    final auth = Get.find<AuthenticationController>();

    if (auth.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not logged in"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (oldPasswordCtrl.text.isEmpty || newPasswordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all password fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await ProfileService().updatepasswordfun(
        user_id: auth.userId!,
        old_password: oldPasswordCtrl.text.trim(),
        new_password: newPasswordCtrl.text.trim(),
      );

      final bool isSuccess =
          response['status'] == true || response['status'] == "success";

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password updated successfully"),
            backgroundColor: Colors.green,
          ),
        );

        // Clear fields after success
        oldPasswordCtrl.clear();
        newPasswordCtrl.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Password update failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
