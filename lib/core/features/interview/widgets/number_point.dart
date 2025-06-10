import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class NumberPoint extends StatelessWidget {
  final String number;
  final String text;

  const NumberPoint({
    super.key,
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.primaryPurple,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.lightText,
              fontSize: 16,
              fontFamily: 'Inter',
              height: 1.40,
            ),
          ),
        ),
      ],
    );
  }
}