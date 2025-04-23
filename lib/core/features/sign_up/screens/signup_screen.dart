import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/sign_in/screens/signin_screen.dart';
import 'package:road_map_mentor/core/features/terms_conditions/screens/terms_conditions_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isChecked = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Link cannot be opened: $url';
    }
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      if (!_isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You must accept the terms & conditions!"))
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
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
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

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

                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text("Sign Up", style: TextStyle(
                      color: const Color(0xFFF0E7FB),
                      fontSize: 32,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.60,
                    ),),
                    SizedBox(height: size.height * 0.03),
                    _buildTextField(Icons.person, "UserName", _usernameController, (value) {
                      if (value == null || value.isEmpty) return "Username is required";
                      if (!RegExp(r'^[a-zA-Z0-9@._-]+$').hasMatch(value)) return "Invalid username format";
                      return null;
                    }),

                    SizedBox(height: size.height * 0.02),

                    _buildTextField(Icons.email, "Email", _emailController, (value) {
                      if (value == null || value.isEmpty) return "Email is required";
                      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                        return "Invalid email format";
                      }
                      return null;
                    }),
                    SizedBox(height: size.height * 0.02),
                    _buildPasswordField("Password", _passwordController, _isPasswordVisible, () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    }),
                    SizedBox(height: size.height * 0.02),
                    _buildPasswordField("Confirm Password", _confirmPasswordController, _isConfirmPasswordVisible, () {
                      setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                    }, (value) {
                      if (value != _passwordController.text) return "Passwords do not match";
                      return null;
                    }),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() => _isChecked = value!);
                          },
                          activeColor: Colors.purpleAccent,
                        ),
                        Text("I agree with ", style: TextStyle(color: Colors.white , fontFamily: 'Inter')),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TermsConditionsScreen()),
                            );
                          },
                          child: Text("terms & conditions", style: TextStyle(color: Color(0xFF9860E4),fontFamily: 'Inter', fontWeight: FontWeight.bold )),
                        )
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    GestureDetector(
                      onTap: _signUp,
                      child: Container(
                        width: double.infinity,
                        height: size.height * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [Color(0xFF7A4DB6), Color(0xFFDFCEF7), Color(0xFFF0E7FB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(child: Text("Sign up", style: TextStyle(
                          color: const Color(0xFF352250),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),)),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text("Sign up with", style: TextStyle(color: Colors.white)),
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
                        Text("Already have an account?", style: TextStyle(color: Colors.white)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => SignInScreen()));
                          },
                          child: Text(
                            " Sign in",
                            style: TextStyle(color: Color(0xFF9860E4), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
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
      IconData icon,
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
          child: Icon(icon, color: const Color(0xFFF5EFFC)),
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
      bool isVisible,
      VoidCallback toggleVisibility,
      [String? Function(String?)? validator]
      ) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator ?? (value) => value!.isEmpty ? "Password is required" : null,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xCCF5EFFC),fontSize: 14,
          fontFamily: 'Inter'),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Icon(Icons.lock, color: const Color(0xFFF5EFFC)),
        ),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
          onPressed: toggleVisibility,
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



  Widget buildSocialButton(String imagePath, String url, double size) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.asset(imagePath, width: size, height: size, fit: BoxFit.cover),
    );
  }

}

class GlassmorphicIcon extends StatelessWidget {
  final String imageUrl;
  final String url;

  const GlassmorphicIcon({
    Key? key,
    required this.imageUrl,
    required this.url,
  }) : super(key: key);

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