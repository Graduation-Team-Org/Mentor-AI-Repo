import 'package:flutter/material.dart';

Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(
                        color: Color(0xFFF5EFFC),
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.17,
                      ),
                    ),
                    TextSpan(
                      text: 'Mentor AI ',
                      style: TextStyle(
                        color: Color(0xFF9860E4),
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 3),
              Image.asset(
                'image/image.png',
                width: 40,
                height: 40,
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Meet our expert AI mentors to gain valuable knowledge and experience.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
