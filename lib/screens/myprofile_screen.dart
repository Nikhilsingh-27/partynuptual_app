import 'package:flutter/material.dart';
import 'package:new_app/screens/widgets/profileimg/imgupload.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      print("⚠️ Delete Account Clicked");
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
                      child:const ProfileImageUploadContainer()
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

  void _printBasicInfo() {
    print("----- BASIC INFO -----");
    print("First Name: ${firstNameCtrl.text}");
    print("Last Name: ${lastNameCtrl.text}");
    print("Gender: $selectedGender");
    print("Address: ${addressCtrl.text}");
    print("Zip: ${zipCtrl.text}");
    print("Email: ${emailCtrl.text}");
    print("Phone: ${phoneCtrl.text}");
  }

  void _printPasswordInfo() {
    print("----- PASSWORD UPDATE -----");
    print("Old Password: ${oldPasswordCtrl.text}");
    print("New Password: ${newPasswordCtrl.text}");
  }
}
