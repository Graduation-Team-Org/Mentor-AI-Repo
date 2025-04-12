import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/home/screens/home_page.dart';
import 'package:road_map_mentor/core/features/sign_up/screens/signup_screen.dart';
import 'package:road_map_mentor/core/features/verification/screens/verification_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF2E1A47),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.07),
                Image.asset("image/image.png", width: size.width * 0.15),
                SizedBox(height: size.height * 0.02),
                Text("Sign In", style: TextStyle(fontSize: size.width * 0.08, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: size.height * 0.03),
                _buildTextField(Icons.email, "Email", _emailController, (value) {
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
                        Text("Remember me", style: TextStyle(color: Colors.white, fontSize: size.width * 0.035)),
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
                        style: TextStyle(color: Color(0xFF9860E4), fontWeight: FontWeight.bold, fontSize: size.width * 0.035),
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
                    child: Center(
                      child: Text("Sign In", style: TextStyle(fontSize: size.width * 0.05, color: Color(0xFF9860E4))),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text("Sign in with", style: TextStyle(color: Colors.white, fontSize: size.width * 0.04)),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.facebook, color: Colors.blueAccent, size: size.width * 0.1),
                      onPressed: () => _launchURL("https://www.facebook.com"),
                    ),
                    SizedBox(width: size.width * 0.02),
                    IconButton(
                      icon: Icon(Icons.apple, color: Colors.white, size: size.width * 0.1),
                      onPressed: () => _launchURL("https://www.apple.com"),
                    ),
                    SizedBox(width: size.width * 0.02),
                    IconButton(
                      icon: Icon(Icons.mail, color: Colors.redAccent, size: size.width * 0.1),
                      onPressed: () => _launchURL("https://www.gmail.com"),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don’t have an account?", style: TextStyle(color: Colors.white, fontSize: size.width * 0.035)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(" Sign up", style: TextStyle(color: Color(0xFF9860E4), fontWeight: FontWeight.bold, fontSize: size.width * 0.04)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, TextEditingController controller, FormFieldValidator<String> validator) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Color(0xFF3E2C5B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        filled: true,
        fillColor: Color(0xFF3E2C5B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? "Password is required" : null,
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Link cannot be opened: $url';
    }
  }

}

