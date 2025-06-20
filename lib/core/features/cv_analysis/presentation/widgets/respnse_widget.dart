import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/builders/pre_element_builder.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';

class ResponseWidget extends StatefulWidget {
  final String responseText;
  final int widgetDuration;

  const ResponseWidget({
    super.key,
    required this.responseText,
    required this.widgetDuration,
  });

  @override
  State<ResponseWidget> createState() => _ResponseWidget2State();
}

class _ResponseWidget2State extends State<ResponseWidget> {
  String _visibleText = "";
  int _currentCharIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _timer =
        Timer.periodic(Duration(milliseconds: widget.widgetDuration), (timer) {
      setState(() {
        // Use characters to correctly handle emojis
        if (_currentCharIndex < widget.responseText.characters.length) {
          _currentCharIndex++;
          _visibleText =
              widget.responseText.characters.take(_currentCharIndex).toString();
        } else {
          _timer.cancel(); // Stop the timer when all text is displayed
        }
      });
    });
  }

  void _showAllText() {
    setState(() {
      _timer.cancel(); // Stop the timer
      _visibleText = widget.responseText; // Show all the text immediately
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
      onDoubleTap: _showAllText,
      child: SelectionArea(
        child: MarkdownBody(
          data: _visibleText,
          // selectable: true,
          styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
          builders: {
            'pre': PreElementBuilder(context),
          },
          styleSheet: MarkdownStyleSheet(
            a: const TextStyle(color: AppColors.white),
            blockquote: const TextStyle(color: AppColors.white),
            checkbox: const TextStyle(color: AppColors.white),
            del: const TextStyle(color: AppColors.white),
            em: const TextStyle(color: AppColors.white),
            h1: const TextStyle(color: AppColors.white),
            h2: const TextStyle(color: AppColors.white),
            listBullet: const TextStyle(color: AppColors.white),
            h6: const TextStyle(color: AppColors.white),
            img: const TextStyle(color: AppColors.white),
            h5: const TextStyle(color: AppColors.white),
            tableHead: const TextStyle(color: AppColors.white),
            tableBody: const TextStyle(color: AppColors.white),
            h3: TextStyle(
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 20),
                  const Offset(150, 20),
                  <Color>[
                    Colors.purpleAccent,
                    AppColors.white,
                  ],
                ),
            ),
            h4: TextStyle(
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 20),
                  const Offset(150, 20),
                  <Color>[
                    Colors.purpleAccent,
                    AppColors.white,
                  ],
                ),
            ),
            strong: const TextStyle(color: AppColors.white),
            codeblockDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            p: TextStyle(
              fontSize: 16,
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 20),
                  const Offset(150, 20),
                  <Color>[
                    AppColors.white,
                    const Color.fromARGB(255, 237, 237, 237),
                  ],
                ),
            ),
          ),
          onTapLink: (text, href, title) {
            if (href != null) {
              onLinkTap(href);
            }
          },
        ),
      ),
    );
  }

  // Function to handle tapping on a link
  void onLinkTap(String markdown) async {
    // final link = extractLink(markdown);
    final link = markdown;
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      print("Could not launch URL: $link");
    }
  }
}
