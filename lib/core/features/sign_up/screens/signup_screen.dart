import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:road_map_mentor/core/features/sign_in/screens/signin_screen.dart';
import 'package:road_map_mentor/core/features/terms_conditions/screens/terms_conditions_screen.dart';
import 'package:road_map_mentor/core/services/firebase_auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _authService = FirebaseAuthService();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isChecked = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Link cannot be opened: $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot open link at this time")));
    }
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("You must accept the terms & conditions!")),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final userCredential =
            await _authService.createUserWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
          _usernameController.text.trim(),
        );

        if (userCredential?.user != null && mounted) {
          _navigateToSignIn();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _signUpWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential?.user != null && mounted) {
        _navigateToSignIn();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToSignIn() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SignInScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } catch (e) {
        debugPrint('Navigation error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("An error occurred. Please try again.")),
          );
        }
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
    // Fix: Properly dispose controllers to avoid memory leaks
    _controller.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
      body: Stack(
        children: [
          // Background effects
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
          SafeArea(
            child: SingleChildScrollView(
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
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint('Error loading image: $error');
                                      return Icon(Icons.error,
                                          size: size.width * 0.15,
                                          color: Colors.white);
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  margin: EdgeInsets.only(left: 0, top: 0),
                                  width: 39.52,
                                  height: 6.27,
                                  decoration: ShapeDecoration(
                                    color: const Color(0x667A4DB6),
                                    shape: OvalBorder(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: const Color(0xFFF0E7FB),
                          fontSize: 32,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.60,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      _buildTextField(

                          Container(
                            width: 16,
                            height: 16,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/images/User.svg',
                              color: Colors.grey,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint('Error loading SVG: $error');
                                return Icon(Icons.person, size: 16, color: Colors.grey);
                              },
                            ),
                          ),

                          "UserName",
                          _usernameController, (value) {
                        if (value == null || value.isEmpty)
                          return "Username is required";
                        if (!RegExp(r'^[a-zA-Z0-9@._-]+$').hasMatch(value))
                          return "Invalid username format";
                        return null;
                      }),
                      SizedBox(height: size.height * 0.02),
                      _buildTextField(

                          Container(
                            width: 16,
                            height: 16,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/images/Letter.svg',
                              color: Colors.grey,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint('Error loading SVG: $error');
                                return Icon(Icons.email, size: 16, color: Colors.grey);
                              },
                            ),

                          ),
                          "Email",
                          _emailController, (value) {
                        if (value == null || value.isEmpty)
                          return "Email is required";
                        if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return "Invalid email format";
                        }
                        return null;
                      }),
                      SizedBox(height: size.height * 0.02),
                      _buildPasswordField(
                          "Password", _passwordController, _isPasswordVisible,
                          () {
                        setState(
                            () => _isPasswordVisible = !_isPasswordVisible);
                      }),
                      SizedBox(height: size.height * 0.02),
                      _buildPasswordField(
                          "Confirm Password",
                          _confirmPasswordController,
                          _isConfirmPasswordVisible, () {
                        setState(() => _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible);
                      }, (value) {
                        if (value != _passwordController.text)
                          return "Passwords do not match";
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
                          Text("I agree with ",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Inter')),
                          InkWell(
                            onTap: () {
                              // Schedule navigation for the next frame to avoid Navigator lock issues
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                try {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          TermsConditionsScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                            opacity: animation, child: child);
                                      },
                                    ),
                                  );
                                } catch (e) {
                                  debugPrint('Navigation error: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "An error occurred. Please try again.")));
                                }
                              });
                            },
                            child: Text("terms & conditions",
                                style: TextStyle(
                                    color: Color(0xFF9860E4),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      InkWell(
                        onTap: _isLoading ? null : _signUp,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
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
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF352250)),
                                  )
                                : const Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: Color(0xFF352250),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text("Sign up with",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GlassmorphicIcon(
                            imageUrl: 'assets/images/facebook.png',
                            url: 'https://www.facebook.com',
                            glassColor: Colors.blue,
                          ),
                          SizedBox(width: size.width * 0.02),
                          GlassmorphicIcon(
                            imageUrl: 'assets/images/apple.png',
                            url: 'https://www.apple.com',
                            glassColor: Colors.black,
                            iconColor: Colors.white,
                          ),
                          SizedBox(width: size.width * 0.02),
                          GlassmorphicIcon(
                            imageUrl: 'assets/images/gmail.png',
                            url: '',
                            glassColor: Colors.red,
                            onTap: _isLoading ? null : _signUpWithGoogle,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                              style: TextStyle(color: Colors.white)),
                          InkWell(
                            // Changed from GestureDetector to InkWell for better feedback
                            onTap: _navigateToSignIn,
                            child: Text(
                              " Sign in",
                              style: TextStyle(
                                  color: Color(0xFF9860E4),
                                  fontWeight: FontWeight.bold),
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
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        hintText: hint,
        hintStyle: TextStyle(
            color: Color(0xCCF5EFFC), fontSize: 14, fontFamily: 'Inter'),
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

  Widget _buildPasswordField(String hint, TextEditingController controller,
      bool isVisible, VoidCallback toggleVisibility,
      [String? Function(String?)? validator]) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator ??
          (value) => value!.isEmpty ? "Password is required" : null,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        hintText: hint,
        hintStyle: TextStyle(
            color: Color(0xCCF5EFFC), fontSize: 14, fontFamily: 'Inter'),
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
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading SVG: $error');
                return Icon(Icons.lock, size: 24, color: Colors.grey);
              },
            ),
          ),
        ),
        suffixIcon: IconButton(
          icon: Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              isVisible ? 'assets/images/eye.svg' : 'assets/images/eye-off.svg',
              color: Colors.grey,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading SVG: $error');
                return Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    size: 16,
                    color: Colors.grey
                );
              },
            ),

          ),
          onPressed: toggleVisibility,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: const Color(0xFF605B6C),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: const Color(0xFF605B6C),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: const Color(0xFF9860E4),
          ),
        ),
      ),
    );
  }
}

class GlassmorphicIcon extends StatelessWidget {
  final String imageUrl;
  final String url;
  final Color? glassColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const GlassmorphicIcon({
    super.key,
    required this.imageUrl,
    required this.url,
    this.glassColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: (glassColor ?? Colors.white).withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
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
                color: iconColor,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error loading image: $error');
                  return Icon(
                    Icons.error_outline,
                    color: iconColor ?? Colors.white,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
