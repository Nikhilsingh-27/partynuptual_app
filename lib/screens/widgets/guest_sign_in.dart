import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';
import 'package:new_app/screens/widgets/guest_sign_up_dart.dart';

import '../../controllers/authentication_controller.dart';
import '../home_page.dart';

class GuestSignIn extends StatefulWidget {
  const GuestSignIn({super.key});

  @override
  State<GuestSignIn> createState() => _GuestSignInState();
}

class _GuestSignInState extends State<GuestSignIn> {
  final auth = Get.find<AuthenticationController>();

  bool _obscurePassword = true;
  bool isloading = false;

  bool emailError = false;
  bool passwordError = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Sign In',
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Guest Sign In",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        "Login to manage your account.",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// Email
                    const Text(
                      "Your Email or Username",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      onChanged: (_) {
                        setState(() => emailError = false);
                      },
                      decoration: InputDecoration(
                        hintText: 'Your Email or Username',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                        ),
                        suffixIcon: emailError
                            ? const Icon(Icons.error_outline, color: Colors.red)
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: emailError ? Colors.red : Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: emailError ? Colors.red : Colors.black,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Password
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (_) {
                        setState(() => passwordError = false);
                      },
                      decoration: InputDecoration(
                        hintText: '6+ characters required',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                        ),
                        suffixIcon: passwordError
                            ? const Icon(Icons.error_outline, color: Colors.red)
                            : IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: passwordError ? Colors.red : Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: passwordError ? Colors.red : Colors.black,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed("/forgotpassword");
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xFFc71f37)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFc71f37),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Sign Up
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GuestSignUp(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFc71f37),
                          side: const BorderSide(color: Color(0xFFc71f37)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isloading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      emailError = _emailController.text.trim().isEmpty;
      passwordError =
          _passwordController.text.trim().isEmpty ||
          _passwordController.text.trim().length < 6;
    });
    if (emailError && passwordError) {
      CustomSnackbar.showError("All fields are required");
      return;
    }
    if (emailError) {
      CustomSnackbar.showError("Email or Username is required");
      return;
    }
    if (_passwordController.text.trim().length == 0) {
      CustomSnackbar.showError("Password is required");
      return;
    }
    if (_passwordController.text.trim().length < 6) {
      CustomSnackbar.showError("Password must be at least 6 characters");
      return;
    }

    setState(() => isloading = true);

    try {
      final response = await auth.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: "guest",
      );

      setState(() => isloading = false);

      final bool isSuccess =
          response["status"] == true || response["status"] == "success";

      if (isSuccess) {
        CustomSnackbar.showSuccess("Login successful!");
        await Future.delayed(const Duration(seconds: 1));
        Get.offAll(() => HomePage());
      } else {
        CustomSnackbar.showError(response["message"] ?? "Login failed");
      }
    } catch (e) {
      setState(() => isloading = false);
      CustomSnackbar.showError("Something went wrong. Please try again.");
    }
  }
}
