import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/sign_in/screens/signin_screen.dart';
import 'package:road_map_mentor/core/features/terms_conditions/screens/terms_conditions_screen.dart';
import 'package:url_launcher/url_launcher.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF2E1A47),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.07),
                Image.asset("image/image.png", width: size.width * 0.15),
                SizedBox(height: size.height * 0.02),
                Text("Sign Up", style: TextStyle(fontSize: size.width * 0.07, fontWeight: FontWeight.bold, color: Colors.white)),
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
                    Text("I agree with ", style: TextStyle(color: Colors.white)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TermsConditionsScreen()),
                        );
                      },
                      child: Text("terms & conditions", style: TextStyle(color: Color(0xFF9860E4), fontWeight: FontWeight.bold)),
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
                    child: Center(child: Text("Sign up", style: TextStyle(fontSize: size.width * 0.05, color: Color(0xFF9860E4)))),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text("Sign up with", style: TextStyle(color: Colors.white)),
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
    );
  }



Widget _buildTextField(IconData icon, String hint, TextEditingController controller, String? Function(String?) validator) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Color(0xFF3E2C5B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility, [String? Function(String?)? validator]) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator ?? (value) => value!.isEmpty ? "Password is required" : null,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Color(0xFF3E2C5B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSocialButton(String imagePath, String url, double size) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.asset(imagePath, width: size, height: size, fit: BoxFit.cover),
    );
  }
}
