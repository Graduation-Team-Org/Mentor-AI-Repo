import 'package:flutter/material.dart';
import 'dart:async';
import 'package:road_map_mentor/core/features/reset_password/screens/reset_password_screen.dart';
import 'package:road_map_mentor/core/services/firebase_auth_service.dart';
import 'dart:ui';

class VerificationCodeScreen extends StatefulWidget {
  final String email;
  final String sentCode;

  const VerificationCodeScreen(
      {super.key, required this.email, required this.sentCode});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen>
    with SingleTickerProviderStateMixin {
  final _authService = FirebaseAuthService();
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  bool _hasError = false;
  int _timerSeconds = 60;
  late Timer _timer;
  bool _canResend = false;
  bool _isLoading = false;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
          _timer.cancel();
        });
      }
    });
  }

  Future<void> _resendCode() async {
    setState(() {
      _timerSeconds = 60;
      _canResend = false;
      _isLoading = true;
    });
    _startTimer();

    try {
      final code =
          await _authService.generateAndStoreVerificationCode(widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New verification code sent')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend code: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> verifyCode() async {
    String enteredCode = _controllers.map((c) => c.text).join();

    setState(() => _isLoading = true);
    try {
      final isValid = await _authService.verifyCode(widget.email, enteredCode);
      if (isValid) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(email: widget.email),
            ),
          );
        }
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
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
                        SizedBox(height: size.height * 0.02),
                        Text(
                          "Verification Code",
                          style: TextStyle(
                            color: const Color(0xFFF0E7FB),
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.60,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 8),
                            Text(
                              "We have sent the verification code to ${widget.email}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70 , fontFamily: 'Inter' , fontSize: 12,),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                width: size.width * 0.10,
                                height: size.width * 0.10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _hasError ? Colors.red : Color(0xFF605B6C),
                                  ),
                                ),
                                child: TextField(
                                  controller: _controllers[index],
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 24),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 3) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              ),
                            );
                          }),

                        ),
                        if (_hasError)
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Incorrect code, please try again.",
                              style: TextStyle(color: Colors.red , fontFamily: 'Inter'),
                            ),
                          ),
                        SizedBox(height: size.height * 0.03),
                        Column(
                          children: [
                            _canResend
                                ? SizedBox.shrink()
                                : RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                                children: [
                                  TextSpan(text: 'Resend OTP in '),
                                  TextSpan(
                                    text: '00:${_timerSeconds.toString().padLeft(2, '0')} s',
                                    style: TextStyle(
                                      color: Color(0xFFB388F2), // اللون البنفسجي الموجود في الصورة
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            _canResend
                                ? GestureDetector(
                              onTap: _resendCode,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                  ),
                                  children: [
                                    TextSpan(text: "Didn't received a code? "),
                                    TextSpan(
                                      text: 'Resend',
                                      style: TextStyle(
                                        color: Color(0xFFB388F2),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(height: size.height * 0.05),
                        GestureDetector(
                          onTap: _isLoading ? null : verifyCode,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
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
                                "Verify",
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
