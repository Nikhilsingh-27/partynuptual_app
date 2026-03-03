import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/data/services/authentication_service.dart';
import 'package:new_app/screens/widgets/custom_snackbar.dart';

class VendorSignUp extends StatefulWidget {
  const VendorSignUp({super.key});

  @override
  State<VendorSignUp> createState() => _VendorSignUpState();
}

class _VendorSignUpState extends State<VendorSignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool isloading = false;

  bool usernameError = false;
  bool emailError = false;
  bool passwordError = false;
  bool confirmPasswordError = false;
  bool termsError = false;

  Timer? _debounce;
  bool? _isUsernameAvailable;
  bool _isCheckingUsername = false;

  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// ================= USERNAME CHECK =================
  void _onUsernameChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() {
      usernameError = false;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _checkUsername(value.trim());
    });
  }

  Future<void> _checkUsername(String username) async {
    if (username.isEmpty) {
      setState(() => _isUsernameAvailable = null);
      return;
    }

    setState(() => _isCheckingUsername = true);

    try {
      final response = await AuthenticationService().checkusername(
        username: username,
      );

      if (!mounted) return;

      setState(() {
        _isUsernameAvailable = response["available"];
        _isCheckingUsername = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isCheckingUsername = false;
        _isUsernameAvailable = null;
      });
    }
  }

  /// ================= SIGNUP =================
  Future<void> _handleSignup() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    /// Reset errors
    setState(() {
      usernameError = false;
      emailError = false;
      passwordError = false;
      confirmPasswordError = false;
      termsError = false;
    });

    /// VALIDATIONS (Same style as Guest)

    if (username.isEmpty) {
      setState(() => usernameError = true);
      CustomSnackbar.showError("Username is required");
      return;
    }

    if (_isCheckingUsername) {
      CustomSnackbar.showError(
        "Please wait while we check username availability",
      );
      return;
    }

    if (_isUsernameAvailable == false) {
      setState(() => usernameError = true);
      CustomSnackbar.showError("This username is already taken");
      return;
    }

    if (email.isEmpty) {
      setState(() => emailError = true);
      CustomSnackbar.showError("Email address is required");
      return;
    }

    if (!_emailRegex.hasMatch(email)) {
      setState(() => emailError = true);
      CustomSnackbar.showError("Please enter a valid email address");
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = true);
      CustomSnackbar.showError("Password is required");
      return;
    }

    if (password.length < 6) {
      setState(() => passwordError = true);
      CustomSnackbar.showError("Password must be at least 6 characters long");
      return;
    }

    if (confirmPassword.isEmpty) {
      setState(() => confirmPasswordError = true);
      CustomSnackbar.showError("Please confirm your password");
      return;
    }

    if (confirmPassword != password) {
      setState(() => confirmPasswordError = true);
      CustomSnackbar.showError("Passwords do not match");
      return;
    }

    if (!_agreeToTerms) {
      setState(() => termsError = true);
      CustomSnackbar.showError(
        "You must accept Terms & Conditions to continue",
      );
      return;
    }

    /// API CALL
    setState(() => isloading = true);

    try {
      final response = await AuthenticationService().signup(
        username: username,
        email: email,
        password: password,
        role: "vendor",
      );

      setState(() => isloading = false);

      final bool isSuccess =
          response["status"] == true || response["status"] == "success";

      if (isSuccess) {
        CustomSnackbar.showSuccessSlow(
          "Signup successful, please check your email to verify your account.\nIf you don't see the email, please check your spam folder.",
        );

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed("/home");
        return;
      }

      final message = response["message"]?.toString() ?? "";

      if (message.contains("Email already")) {
        setState(() => emailError = true);
        CustomSnackbar.showError(
          "This email is already registered. Please login instead.",
        );
      } else if (message.contains("Username")) {
        setState(() => usernameError = true);
        CustomSnackbar.showError(message);
      } else {
        CustomSnackbar.showError(
          message.isNotEmpty ? message : "Signup failed. Please try again.",
        );
      }
    } catch (_) {
      setState(() => isloading = false);
      CustomSnackbar.showError(
        "Network error. Please check your connection and try again.",
      );
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Sign Up',
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
                        "Vendor Sign Up",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// USERNAME
                    _buildTextField(
                      label: "Username",
                      controller: _usernameController,
                      error: usernameError,
                      onChanged: _onUsernameChanged,
                      suffix: _isCheckingUsername
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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

                    /// EMAIL
                    _buildTextField(
                      label: "Email",
                      controller: _emailController,
                      error: emailError,
                    ),

                    /// PASSWORD
                    _buildTextField(
                      label: "Password",
                      controller: _passwordController,
                      error: passwordError,
                      obscure: _obscurePassword,
                      toggleObscure: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),

                    /// CONFIRM PASSWORD
                    _buildTextField(
                      label: "Confirm Password",
                      controller: _confirmPasswordController,
                      error: confirmPasswordError,
                      obscure: _obscureConfirmPassword,
                      toggleObscure: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    /// TERMS
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                              termsError = false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "I agree to Terms & Conditions",
                            style: TextStyle(
                              color: termsError ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFc71f37),
                          foregroundColor: Colors.white,
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

  /// ================= COMMON TEXTFIELD =================
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool error,
    bool obscure = false,
    VoidCallback? toggleObscure,
    Widget? suffix,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscure,
            onChanged:
                onChanged ??
                (_) {
                  setState(() {});
                },
            decoration: InputDecoration(
              suffixIcon: error
                  ? const Icon(Icons.error_outline, color: Colors.red)
                  : toggleObscure != null
                  ? IconButton(
                      icon: Icon(
                        obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: toggleObscure,
                    )
                  : suffix,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: error ? Colors.red : Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: error ? Colors.red : Colors.black,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
