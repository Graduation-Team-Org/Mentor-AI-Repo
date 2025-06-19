import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import 'package:road_map_mentor/core/features/verification_code/screens/verification_code_screen.dart';
import 'package:road_map_mentor/core/services/firebase_auth_service.dart';

import 'dart:ui';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _authService = FirebaseAuthService();
  bool _isLoading = false;

  TextEditingController emailController = TextEditingController();
  String? errorMessage;

  String generateVerificationCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  void validateAndContinue() async {
    setState(() {
      String email = emailController.text.trim();

      if (email.isEmpty) {
        errorMessage = "Please enter your email";
        return;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        errorMessage = "Please enter a valid email";
        return;
      } else {
        errorMessage = null;
      }
    });

    if (errorMessage == null) {
      setState(() => _isLoading = true);
      try {
        final code = await _authService
            .generateAndStoreVerificationCode(emailController.text.trim());
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationCodeScreen(
                email: emailController.text.trim(),
                sentCode: code,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            errorMessage = e.toString();
          });
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
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
                    shape: BoxShape.circle, color: Color(0xFF40174C)),
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.05,
                        left: size.width * 0.06,
                        right: size.width * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.02),
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
                          "Verification",
                          style: TextStyle(
                            color: const Color(0xFFF0E7FB),
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.60,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "Enter your email to send OTP code",
                          style: TextStyle(
                              fontFamily: 'Inter', color: Colors.white70),
                        ),
                        SizedBox(height: size.height * 0.04),
                        TextField(
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Color(0xCCF5EFFC),
                                fontSize: 14,
                                fontFamily: 'Inter'),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Container(
                                width: 16,
                                height: 16,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/images/Letter.svg',
                                  color: Colors.grey,
                                  fit: BoxFit.contain,
                                ),
                              ),
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

                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 1.5,
                                color: Color(0xFF9860E4),
                              ),
                            ),
                            errorStyle: const TextStyle(
                              color: Color(0xFF9860E4),
                              fontFamily: 'Inter',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (errorMessage != null)
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              errorMessage!,
                              style: TextStyle(color: Color(0xFF9860E4)),
                            ),
                          ),
                        SizedBox(height: size.height * 0.04),
                        GestureDetector(
                          onTap: _isLoading ? null : validateAndContinue,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF7A4DB6),
                                  Color(0xFFDFCEF7),
                                  Color(0xFFF0E7FB)
                                ],
                              ),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF352250)),
                                    )
                                  : Text(
                                      "Send Reset Link",
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
