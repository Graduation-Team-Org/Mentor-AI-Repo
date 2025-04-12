import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/sign_in/screens/signin_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? errorMessage;

  void resetPassword() {
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      if (password.isEmpty || confirmPassword.isEmpty) {
        errorMessage = "Please fill in both fields";
      } else if (password.length < 6) {
        errorMessage = "Password must be at least 6 characters";
      } else if (password != confirmPassword) {
        errorMessage = "Passwords do not match!";
      } else {
        errorMessage = null;
        _showSuccessDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF2E1A47),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),
              Image.asset("image/image.png", width: size.width * 0.2),
              SizedBox(height: size.height * 0.03),

              Text(
                "Reset Password",
                style: TextStyle(fontSize: size.width * 0.07, fontWeight: FontWeight.bold, color: Colors.white),
              ),

              SizedBox(height: size.height * 0.01),
              Text(
                "Enter your new password",
                style: TextStyle(fontSize: size.width * 0.04, color: Colors.white70),
              ),

              SizedBox(height: size.height * 0.05),

              _buildPasswordField("Password", _passwordController, _isObscure1, () {
                setState(() {
                  _isObscure1 = !_isObscure1;
                });
              }),

              SizedBox(height: size.height * 0.025),

              _buildPasswordField("Confirm Password", _confirmPasswordController, _isObscure2, () {
                setState(() {
                  _isObscure2 = !_isObscure2;
                });
              }),

              if (errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: size.width * 0.04),
                  ),
                ),

              SizedBox(height: size.height * 0.05),

              GestureDetector(
                onTap: resetPassword,
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7A4DB6),
                        Color(0xFFDFCEF7),
                        Color(0xFFF0E7FB),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E1A47),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller, bool isObscure, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off, color: Colors.white),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: const Color(0xFF3E2C5B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Your password has been reset successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
