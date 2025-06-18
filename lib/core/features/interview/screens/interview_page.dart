// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/constants.dart';
import '../widgets/number_point.dart';
import '../widgets/gradient_button.dart';
import '../utils/background_decorations.dart';
import 'field_selection_page.dart';

class InterviewPage extends StatelessWidget {
  const InterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const BackgroundDecorations(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button and header
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Centered Welcome text
                        const Text(
                          'Welcome! 🎉',
                          style: TextStyle(
                            color: AppColors.lightText,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            height: 1.40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Back button in the top left
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => context.go('/home'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Introduction text
                    const Text(
                      'Congratulations on reaching this stage! Before you start the interview, there are just two simple steps:',
                      style: TextStyle(
                        color: AppColors.lightText,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        height: 1.40,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Numbered steps
                    const NumberPoint(
                      number: '1',
                      text: 'Select the field you want to be interviewed in.',
                    ),
                    const SizedBox(height: 14),

                    const NumberPoint(
                      number: '2',
                      text:
                          'Choose your level to get questions that match your experience.',
                    ),
                    const SizedBox(height: 14),

                    // Additional info
                    const Text(
                      'Once you press "Start", you\'ll meet David, who will conduct your interview.',
                      style: TextStyle(
                        color: AppColors.lightText,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        height: 1.40,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Interview details section
                    const Text(
                      'Interview Details:',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 20,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDetailRow('Number of questions:', '5'),
                    _buildDetailRow('Duration:', '10 minutes'),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          height: 1.40,
                        ),
                        children: [
                          TextSpan(
                            text: 'Time limit:  ',
                            style: TextStyle(color: AppColors.primaryPurple),
                          ),
                          TextSpan(
                            text:
                                'Once the time is up, you won\'t be able to continue. Press "Finish" to see your score, weaknesses, and recommendations to improve.',
                            style: TextStyle(color: AppColors.lightText),
                          ),
                        ],
                      ),
                    ),

                    // GO button
                    const SizedBox(height: 30),
                    GradientButton(
                      text: "GO",
                      height: 75,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FieldSelectionPage(),
                          ),
                        );
                      },
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.lightText,
              fontSize: 16,
              fontFamily: 'Inter',
              height: 1.40,
            ),
          ),
        ],
      ),
    );
  }
}
