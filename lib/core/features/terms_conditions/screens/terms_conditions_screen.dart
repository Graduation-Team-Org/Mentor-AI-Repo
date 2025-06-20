import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/sign_up/screens/signup_screen.dart';

Widget _buildSection(String title, List<String> content, {String? sectionNumber}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0), // Spacing between sections
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionNumber != null ? "$sectionNumber. $title" : title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Inter', // Apply font family
          ),
        ),
        const SizedBox(height: 8), // Space between title and content
        ...content.map((text) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0), // Spacing for list items/paragraphs
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Inter', // Apply font family
                height: 1.5, // Adjust line height for readability
              ),
            ),
          );
        }).toList(),
      ],
    ),
  );
}

// Dummy _Accept function
void _Accept(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("An error occurred. Please try again.")),
        );
      }
    }
  });
}


class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
                  color: Color(0xFF40174C),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
                    child: SizedBox(
                      height: 56, // ارتفاع شبيه بالـ AppBar
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // النص في المنتصف بالضبط
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          // الأيقونة في أقصى اليسار
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Removed the extra SizedBox and Center Text widget here
                  const SizedBox(height: 16), // Space between AppBar and first section
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.6,
                                  fontFamily: 'Inter',
                                ),
                                children: [
                                  const TextSpan(text: "Welcome to "),
                                  TextSpan(
                                    text: "Mentor AI! ",
                                    style: TextStyle(color: Color(0xFF9860E4)),
                                  ),
                                  const TextSpan(
                                    text:
                                    "These Terms and Conditions (\"Terms\") govern your access to and use of our mobile provided by ",
                                  ),
                                  TextSpan(
                                    text: "Mentor AI! ",
                                    style: TextStyle(color: Color(0xFF9860E4)),
                                  ),
                                  const TextSpan(text: " (\"we\", \"us\", or \"our\")."),
                                ],
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              "By accessing or using the Service, you agree to be bound by these Terms. If you do not agree, please do not use our application.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.6,
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          _buildSection(
                            "Purpose of the Service",
                            [
                              "Our platform offers AI-driven career and learning support tools, including but not limited to:",
                              "• Personalized Roadmap Generation",
                              "• Chat with Uploaded Documents",
                              "• Resume Analysis",
                              "• Resume Generation",
                              "• Mock Technical Interviews",
                              "All services are designed to provide mentorship-like guidance to individuals in the tech and software engineering fields.",
                            ],
                            sectionNumber: "1",
                          ),
                          _buildSection(
                            "AI Usage and Limitations",
                            [
                              "Our app uses AI models (including OpenAI’s GPT-4o and GPT-3.5 Turbo) to generate content.",
                              "Content generated by the AI is based on best practices but should not be considered as professional or legal advice.",
                              "We do not guarantee the absolute accuracy, correctness, or completeness of AI-generated outputs.",
                            ],
                            sectionNumber: "2",
                          ),
                          _buildSection(
                            "User Data and File Uploads",
                            [
                              "Uploaded documents (PDFs, resumes, notes) are temporarily processed to provide services like document chat or resume analysis.",
                              "By uploading, you confirm that you have the right to use and share those files.",
                              "We do not store or share your documents beyond what’s needed for immediate processing, unless explicitly stated.",
                            ],
                            sectionNumber: "3",
                          ),
                          _buildSection(
                            "Privacy and Security",
                            [
                              "We take your privacy seriously. Please refer to our [Privacy Policy] for detailed information on how we collect and use your data.",
                              "Authentication is handled securely via Firebase.",
                              "We use local device storage (Hive and SharedPreferences) to cache user progress, preferences, and settings.",
                            ],
                            sectionNumber: "4",
                          ),
                          _buildSection(
                            "User Responsibilities",
                            [
                              "By using this app, you agree:",
                              "Not to use the service for illegal or unauthorized purposes.",
                              "Not to upload harmful, copyrighted, or offensive material.",
                              "To use AI outputs responsibly and verify critical information independently.",
                            ],
                            sectionNumber: "5",
                          ),
                          _buildSection(
                            "Availability and Changes",
                            [
                              "We reserve the right to modify or discontinue any part of the Service at any time, with or without notice.",
                              "Features and AI responses may evolve as the models and infrastructure improve.",
                            ],
                            sectionNumber: "6",
                          ),
                          _buildSection(
                            "Intellectual Property",
                            [
                              "All intellectual property related to app structure, design, branding, and original content remains the property of [Your Company Name].",
                              "Users retain ownership of their uploaded files and resume content.",
                            ],
                            sectionNumber: "7",
                          ),
                          _buildSection(
                            "Subscription and API Usage",
                            [
                              "Some features may require API access or subscription to third-party providers (e.g., OpenAI, AssemblyAI).",
                              "You are responsible for managing your access keys or subscriptions if you use your own.",
                            ],
                            sectionNumber: "8",
                          ),
                          _buildSection(
                            "Termination",
                            [
                              "We may suspend or terminate your access to the app at our sole discretion if you violate these Terms or misuse the Service.",
                            ],
                            sectionNumber: "9",
                          ),
                          _buildSection(
                            "Contact",
                            [
                              "For support, inquiries, or legal concerns, please contact us at:\n📧 support@mentorai.app",
                            ],
                            sectionNumber: "10",
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 14.0),
                            child: Text(
                              "By continuing to use the app, you confirm that you have read, understood, and agreed to these Terms and Conditions.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.6,
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _Accept(context),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          // Adjusted colors for a more subtle gradient like in the image
                          colors: [
                            Color(0xFF7A4DB6), // A slightly darker purple
                            Color(0xFFB593E0), // Mid-range purple
                            Color(0xFFEDE4F8), // Very light purple
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: Color(0xFF352250), // Darker text for contrast on light gradient
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

        ],

      ),
    );
  }
}
