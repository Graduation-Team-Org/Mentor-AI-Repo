import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/builders/pre_element_builder.dart';
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';

class ResponseWidget extends StatefulWidget {
  final String responseText;

  const ResponseWidget({
    super.key,
    required this.responseText,
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
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
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
            h3: TextStyle(
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 20),
                  const Offset(150, 20),
                  <Color>[
                    const Color(0xff220901),
                    const Color(0xff941b0c),
                  ],
                ),
            ),
            h4: TextStyle(
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 20),
                  const Offset(150, 20),
                  <Color>[
                    Colors.red,
                    Colors.blue.shade900,
                  ],
                ),
            ),
            strong: const TextStyle(color: Color(0xff2c2217)),
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
                    Colors.black,
                    const Color.fromARGB(255, 81, 81, 81),
                  ],
                ),
            ),
          ),
          onTapLink: (text, href, title) {
            print("Txt=> $text, Link=>$href, title=>$title");
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
    print(link);
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      print("Could not launch URL: $link");
    }
  }
}
