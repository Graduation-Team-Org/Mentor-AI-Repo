import 'package:flutter/material.dart';
import 'dart:async';
import 'reset_password_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;
  final String sentCode;

  VerificationCodeScreen({required this.email, required this.sentCode});

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  bool _hasError = false;
  int _timerSeconds = 60;
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

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

  void _resendCode() {
    setState(() {
      _timerSeconds = 60;
      _canResend = false;
    });
    _startTimer();
    print("Verification code resent to ${widget.email}");
  }

  void verifyCode() {
    String enteredCode = _controllers.map((c) => c.text).join();

    if (enteredCode == widget.sentCode) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF2E1A47),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.02),
            Image.asset("image/image.png", height: size.height * 0.12),
            SizedBox(height: size.height * 0.02),
            Text(
              "Verification Code",
              style: TextStyle(
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text(
                  "A 4-digit code has been sent to ${widget.email}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: size.width * 0.15,
                  height: size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Color(0xFF3E2C5B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _hasError ? Colors.red : Colors.transparent),
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    decoration: InputDecoration(counterText: "", border: InputBorder.none),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            if (_hasError)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Incorrect code, please try again.",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: size.height * 0.03),
            _canResend
                ? GestureDetector(
              onTap: _resendCode,
              child: Text(
                "Resend Code",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
                : Text(
              "Resend OTP in ${_timerSeconds}s",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: size.height * 0.05),
            GestureDetector(
              onTap: verifyCode,
              child: Container(
                width: double.infinity,
                height: size.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xFF7A4DB6), Color(0xFFDFCEF7), Color(0xFFF0E7FB)],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Verify",
                    style: TextStyle(
                      color: Color(0xFF2E1A47),
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
