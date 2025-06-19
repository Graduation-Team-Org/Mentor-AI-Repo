import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:road_map_mentor/core/features/sign_in/screens/signin_screen.dart';
import 'dart:ui';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required String email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

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
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF110A2B),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 300,
            left: 60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF352250),
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -70,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF9860E4),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 200,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF9860E4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF40174C)
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.translate(
                              offset: Offset(0, _animation.value),
                              child: Image.asset(
                                "assets/images/image.png",
                                width: size.width * 0.15,
                              ),
                            ),
                            SizedBox(height: 8),
                            Positioned(
                              left: 63.24,
                              top: 85.30,
                              child: Container(
                                width: 39.52,
                                height: 6.27,
                                decoration: ShapeDecoration(
                                  color: const Color(0x667A4DB6),
                                  shape: OvalBorder(),
                                ),
                              ),
                            ),

                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),

                  Text(
                    "Reset Password",
                    style:  TextStyle(
                      color: const Color(0xFFF0E7FB),
                      fontSize: 32,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.60,
                    ),
                  ),

                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Enter your new password",
                    style: TextStyle(fontFamily: 'Inter', color: Colors.white70),
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
                        style: TextStyle(color: Colors.red, fontSize: size.width * 0.035),
                      ),
                    ),

                  SizedBox(height: size.height * 0.05),

                  GestureDetector(
                    onTap: resetPassword,
                    child: Container(
                      width: double.infinity,
                      height: 50,
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
                            color: const Color(0xFF352250),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
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
        ],
      ),

    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller, bool isObscure, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xCCF5EFFC),fontSize: 14,
            fontFamily: 'Inter'),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/images/Lock_Keyhole_Minimalistic.svg',
              color: Colors.grey,
              fit: BoxFit.contain,
            ),
          ),
        ),
        suffixIcon: IconButton(
          icon: Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              isObscure ? 'assets/images/eye-off.svg' : 'assets/images/eye.svg',
              color: Colors.grey,
              fit: BoxFit.contain,
            ),
          ),
          onPressed: toggleVisibility,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xFF605B6C),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xFF605B6C),
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1.5,
            color: Color(0xFF9860E4),
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1.5,
            color: Color(0xFF9860E4),
          ),
        ),

        errorStyle: TextStyle(
          color: Color(0xFF9860E4),
          fontFamily: 'Inter',
          fontSize: 12,
        ),
      ),
    );
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF2E1A47).withOpacity(0.7),

          insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF2E1A47), width: 2),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Success",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your password has been reset successfully.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7A4DB6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
