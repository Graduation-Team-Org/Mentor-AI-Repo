import 'package:flutter/material.dart';

class SenderAvatar extends StatelessWidget {
  const SenderAvatar({
    super.key,
    required this.senderAvatar,
  });

  final String senderAvatar;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          senderAvatar,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
