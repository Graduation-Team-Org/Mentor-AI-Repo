import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  bool _isNavigating = false; // Flag to prevent multiple navigation attempts

  void launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Link cannot be opened: $url');
      }
    } catch (e) {
      debugPrint('URL launch error: $e');
    }
  }

  void _signIn() {
    if (_formKey.currentState!.validate() && !_isNavigating) {
      _isNavigating = true;

      // Use post-frame callback to ensure navigation happens after the current frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>  HomePage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 1.0;
                var tween = Tween(begin: begin, end: end);
                var fadeAnimation = animation.drive(tween);
                return FadeTransition(opacity: fadeAnimation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        } catch (e) {
          _isNavigating = false;
          debugPrint('Navigation error: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("An error occurred. Please try again."))
            );
          }
        }
      });
    }
  }

  void _navigateToSignUp() {
    if (_isNavigating) return;
    _isNavigating = true;

    // Use post-frame callback to ensure navigation happens after the current frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      try {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = 0.0;
              const end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var fadeAnimation = animation.drive(tween);
              return FadeTransition(opacity: fadeAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ).then((_) {
          // Reset navigation flag when returning from the next screen
          _isNavigating = false;
        });
      } catch (e) {
        _isNavigating = false;
        debugPrint('Navigation error to SignUp: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Unable to open Sign Up screen. Please try again."))
          );
        }
      }
    });
  }

  void _navigateToVerification() {
    if (_isNavigating) return;
    _isNavigating = true;

    // Use post-frame callback to ensure navigation happens after the current frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      try {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const VerificationScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = 0.0;
              const end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var fadeAnimation = animation.drive(tween);
              return FadeTransition(opacity: fadeAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ).then((_) {
          // Reset navigation flag when returning from the next screen
          _isNavigating = false;
        });
      } catch (e) {
        _isNavigating = false;
        debugPrint('Navigation error to Verification: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Unable to open Verification screen. Please try again."))
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
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF110A2B),
      body: SafeArea(
        child: Stack(
          children: [
            // Background elements
            _buildBackgroundEffects(),

            // Main content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.07),
                      _buildAnimatedLogo(size),
                      SizedBox(height: size.height * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extract background elements to a separate method
  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        Positioned(
          top: 300,
          left: 60,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
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
              decoration: const BoxDecoration(
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
              decoration: const BoxDecoration(
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
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF40174C)
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Extract animated logo to a separate method for better readability
  Widget _buildAnimatedLogo(Size size) {
    return AnimatedBuilder(
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
                  return SizedBox(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    child: const Icon(Icons.image, color: Colors.white54),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 39.52,
              height: 6.27,
              decoration: const ShapeDecoration(
                color: Color(0x667A4DB6),
                shape: OvalBorder(),
              ),
            ),

            SizedBox(height: size.height * 0.02),
            const Text(
              "Sign In",
              style: TextStyle(
                color: Color(0xFFF0E7FB),
                fontSize: 32,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.60,
              ),
            ),
            SizedBox(height: size.height * 0.03),

            // Email field
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
                      return const Icon(Icons.email, color: Colors.grey);
                    },
                  ),
                ),
                "Email",
                _emailController,
                    (value) {
                  if (value == null || value.isEmpty) return "Email is required";
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return "Invalid email format";
                  }
                  return null;
                }
            ),
            SizedBox(height: size.height * 0.02),

            // Password field
            _buildPasswordField("Password", _passwordController),
            SizedBox(height: size.height * 0.015),

            // Remember me and Forgot Password row
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Text(
                        "Remember me",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter'
                        )
                    ),
                  ],
                ),
                InkWell(
                  onTap: _navigateToVerification,
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Color(0xFF9860E4),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter'
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),

            // Sign In button
            InkWell(
              onTap: _signIn,
              child: Container(
                width: double.infinity,
                height: size.height * 0.07,
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
                child: const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color(0xFF352250),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),

            // Sign in with text
            const Text(
                "Sign in with",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter'
                )
            ),
            SizedBox(height: size.height * 0.02),

            // Social login options
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
                  url: 'https://www.gmail.com',
                  glassColor: Colors.red,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),

            // Don't have an account row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white)
                ),
                InkWell(
                  onTap: _navigateToSignUp,
                  child: const Text(
                    " Sign up",
                    style: TextStyle(
                        color: Color(0xFF9860E4),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
          ],
        );
      },
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        hintText: hint,
        hintStyle: const TextStyle(
            color: Color(0xCCF5EFFC),
            fontSize: 14,
            fontFamily: 'Inter'
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: iconWidget,
        ),
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFF605B6C),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFF605B6C),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1.5,
            color: Color(0xFF9860E4),
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xCCF5EFFC),
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        filled: true,
        fillColor: Colors.black12,
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
                return const Icon(Icons.lock, color: Colors.grey);
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
              _isPasswordVisible
                  ? 'assets/images/eye.svg'
                  : 'assets/images/eye-off.svg',
              color: Colors.grey,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading SVG: $error');
                return Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFFF5EFFC),
                );
              },
            ),
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFF605B6C),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFF605B6C),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1.5,
            color: Color(0xFF9860E4),
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
  final Color? glassColor;
  final Color? iconColor;

  const GlassmorphicIcon({
    super.key,
    required this.imageUrl,
    required this.url,
    this.glassColor,
    this.iconColor,
  });

  void _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('URL launch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(url),
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