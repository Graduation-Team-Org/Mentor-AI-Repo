import 'package:flutter/material.dart';
import 'dart:math';

import 'package:road_map_mentor/core/features/verification_code/screens/verification_code_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController emailController = TextEditingController();
  String? errorMessage;

  String generateVerificationCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  void validateAndContinue() {
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

      String code = generateVerificationCode();


      print("Verification code sent $code to $email");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationCodeScreen(
            email: email,
            sentCode: code,
          ),
        ),
      );
    });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.05, left: size.width * 0.06, right: size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("image/image.png", width: size.width * 0.2),
              SizedBox(height: size.height * 0.03),

              Text(
                "Verification",
                style: TextStyle(
                  fontSize: size.width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.01),

              Text(
                "Enter your email to send OTP code",
                style: TextStyle(fontSize: size.width * 0.04, color: Colors.white70),
              ),
              SizedBox(height: size.height * 0.04),

              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF3E2C5B),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              if (errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              SizedBox(height: size.height * 0.04),

              GestureDetector(
                onTap: validateAndContinue,
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [Color(0xFF7A4DB6), Color(0xFFDFCEF7), Color(0xFFF0E7FB)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        color: Color(0xFF2E1A47),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
