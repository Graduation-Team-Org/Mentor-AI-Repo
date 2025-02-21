import 'dart:async';

import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/functions/fun.dart';

class AnimatedTextWidget extends StatefulWidget {
  final String response;

  const AnimatedTextWidget({super.key, required this.response});

  @override
  GeminiAnimatedTextWidgetState createState() =>
      GeminiAnimatedTextWidgetState();
}

class GeminiAnimatedTextWidgetState extends State<AnimatedTextWidget> {
  String _visibleText = "";
  int _currentCharIndex = 0;
  late Timer _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        // Use characters to correctly handle emojis
        if (_currentCharIndex < widget.response.characters.length) {
          _currentCharIndex++;
          _visibleText =
              widget.response.characters.take(_currentCharIndex).toString();
              Fun().scrollToBottom(scrollController: _scrollController);
        } else {
          _timer.cancel(); // Stop the timer when all text is displayed
        }
      });
    });
  }

  void _showAllText() {
    setState(() {
      _timer.cancel(); // Stop the timer
      _visibleText = widget.response; // Show all the text immediately
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _showAllText, // Handle double-tap to show all text
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Text(
          _visibleText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

