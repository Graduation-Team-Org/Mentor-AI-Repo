import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TypingAnimation extends StatelessWidget {
  const TypingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Lottie.asset('assets/images/typing-animation .json'),
    );
  }
}