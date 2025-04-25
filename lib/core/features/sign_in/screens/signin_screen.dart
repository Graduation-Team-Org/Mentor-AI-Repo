import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:road_map_mentor/core/features/sign_up/screens/signup_screen.dart';
import 'package:road_map_mentor/core/features/verification/screens/verification_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:road_map_mentor/core/features/home/screens/home_page.dart';
import 'dart:ui';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Link cannot be opened: $url';
    }
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
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
                    shape: BoxShape.circle,
                    color: Color(0xFF40174C)
                ),
              ),
            ),
          ),SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Form(
                  key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          SizedBox(height: size.height * 0.07),
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

                                    SizedBox(height: size.height * 0.02),
                                    Text("Sign In", style: TextStyle(
                                      color: const Color(0xFFF0E7FB),
                                      fontSize: 32,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      height: 1.60,
                                    ),),
                                    SizedBox(height: size.height * 0.03),
                                    _buildTextField(SvgPicture.asset(
                                      'assets/images/Letter.svg',
                                      width: 24,
                                      height: 24,
                                      color: Colors.grey,), "Email", _emailController, (value) {
                                      if (value == null || value.isEmpty) return "Email is required";
                                      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                        return "Invalid email format";
                                      }
                                      return null;
                                    }),
                                    SizedBox(height: size.height * 0.02),
                                    _buildPasswordField("Password", _passwordController),
                                    SizedBox(height: size.height * 0.015),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: _rememberMe,
                                              onChanged: (value) {
                                                setState(() => _rememberMe = value!);
                                              },
                                              activeColor: Colors.purpleAccent,
                                            ),
                                            Text("Remember me",  style: TextStyle(color: Colors.white , fontFamily: 'Inter')),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => VerificationScreen()),
                                            );
                                          },
                                          child: Text(
                                            "Forgot Password?",
                                            style: TextStyle(color: Color(0xFF9860E4), fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    GestureDetector(
                                      onTap: _signIn,
                                      child: Container(
                                        width: double.infinity,
                                        height: size.height * 0.08,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF7A4DB6),
                                              Color(0xFFDFCEF7),
                                              Color(0xFFF0E7FB),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(child: Text("Sign In", style: TextStyle(
                                          color: const Color(0xFF352250),
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),)),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    Text("Sign in with",  style: TextStyle(color: Colors.white , fontFamily: 'Inter')),
                                    SizedBox(height: size.height * 0.02),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GlassmorphicIcon(
                                          imageUrl: 'assets/images/facebook.png',
                                          url: 'https://www.facebook.com',
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        GlassmorphicIcon(
                                          imageUrl: 'assets/images/apple.png',
                                          url: 'https://www.apple.com',
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        GlassmorphicIcon(
                                          imageUrl: 'assets/images/gmail.png',
                                          url: 'https://www.gmail.com',
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Don’t have an account?", style: TextStyle(color: Colors.white)),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context, MaterialPageRoute(builder: (context) => SignUpScreen()),
                                            );
                                          },
                                          child: Text(" Sign up", style: TextStyle(color: Color(0xFF9860E4), fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),

                                  ],
                                );
                              },
                            ),
                          ),

                        ],
                    ),
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      Widget iconWidget,
      String hint,
      TextEditingController controller,
      String? Function(String?) validator,
      ) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xCCF5EFFC),fontSize: 14,
            fontFamily: 'Inter'),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: iconWidget,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: const Color(0xFF605B6C),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String hint,
      TextEditingController controller,
      ) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Color(0xCCF5EFFC),
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: SvgPicture.asset(
            'assets/images/Lock_Keyhole_Minimalistic.svg',
            width: 24,
            height: 24,
            color: Colors.grey,
          ),
        ),
        suffixIcon: IconButton(
          icon: SvgPicture.asset(
            _isPasswordVisible
                ? 'assets/images/eye.svg'
                : 'assets/images/eye-off.svg',
            color: const Color(0xFFF5EFFC),
            height: 24,
            width: 24,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: const Color(0xFF605B6C),
          ),
        ),
      ),
      validator: (value) => value!.isEmpty ? "Password is required" : null,
    );
  }



}

class GlassmorphicIcon extends StatelessWidget {
  final String imageUrl;
  final String url;

  const GlassmorphicIcon({
    super.key,
    required this.imageUrl,
    required this.url,
  });

  _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}