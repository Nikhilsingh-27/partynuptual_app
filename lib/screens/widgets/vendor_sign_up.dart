import 'package:flutter/material.dart';
import 'package:new_app/data/services/authentication_service.dart';
import 'package:new_app/screens/home_page.dart';
import 'dart:async';
import 'package:get/get.dart';
class VendorSignUp extends StatefulWidget {
  const VendorSignUp({super.key});

  @override
  State<VendorSignUp> createState() => _VendorSignUpState();
}

class _VendorSignUpState extends State<VendorSignUp> {
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Timer? _debounce;
  bool? _isUsernameAvailable; // null = not checked yet
  bool _isCheckingUsername = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  void _onSearchChanged(String value) {
    // cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      // 👇 this runs when user stops typing
      print("User stopped typing: $value");
      searchApi(value);
    });
  }

  void searchApi(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isUsernameAvailable = null;
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
    });

    try {
      final response =
      await AuthenticationService().checkusername(username: query);
      print(response["available"]);
      setState(() {
        _isUsernameAvailable = response["available"];
        _isCheckingUsername = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingUsername = false;
        _isUsernameAvailable = null;
      });
    }
  }

  void signup(String username,String email,String password,String role)async{

    final response = await AuthenticationService().signup(username: username, email: email, password: password, role: role);
    if(response["message"]=="Email already registered"){
      Get.toNamed("/home");
      Get.snackbar(
        "Email already registered",
        "Please verify your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }
    else {
      Get.toNamed("/home");
      Get.snackbar(
        "Signup Successful 🎉",
        "Please verify your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Sign UP',
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
          ),
        ),

      ),

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Vendor Sign Up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your account.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'User Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),

                    // 👇 suffix icon (loader / check / cross)
                    suffixIcon: _isCheckingUsername
                        ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                        : _isUsernameAvailable == null
                        ? null
                        : Icon(
                      _isUsernameAvailable!
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: _isUsernameAvailable!
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '6+ characters required',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the Terms and Conditions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isCheckingUsername) {
                        Get.snackbar(
                          "Please wait",
                          "Checking username availability",
                        );
                        return;
                      }

                      if (_isUsernameAvailable == false) {
                        Get.snackbar(
                          "Username Taken",
                          "Please choose another username",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      if (_usernameController.text.trim().isEmpty ||
                          _emailController.text.trim().isEmpty ||
                          _passwordController.text.trim().isEmpty) {
                        Get.snackbar(
                          "Missing Information",
                          "All fields are required",
                        );
                        return;
                      }
                      if (_passwordController.text.trim().length < 6) {
                        Get.snackbar(
                          "Weak Password",
                          "Password must be at least 6 characters long",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      if (!_agreeToTerms) {
                        Get.snackbar(
                          "Terms Required",
                          "Please accept Terms & Conditions",
                        );
                        return;
                      }

                      // ✅ Safe to signup
                      signup(
                        _usernameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        "vendor",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

