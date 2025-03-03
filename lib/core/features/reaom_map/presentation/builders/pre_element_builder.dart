import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:ui' as ui;

import 'package:road_map_mentor/core/utils/colors.dart';

class PreElementBuilder extends MarkdownElementBuilder {
  final BuildContext parentContext;

  PreElementBuilder(this.parentContext);
  @override
  Widget? visitText(text, preferredStyle) {
    final codeText = text.text; // Extract the code block content

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(
              codeText,
              style: TextStyle(
                backgroundColor:AppColors.white.withValues(alpha: 0.2),
                foreground: Paint()
                  ..shader = ui.Gradient.linear(
                    const Offset(0, 20),
                    const Offset(150, 20),
                    <Color>[
                      Colors.red,
                      Colors.blue,
                    ],
                  ),
                fontSize: 14,
                fontFamily: 'Courier',
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.copy, color: Colors.black),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: codeText));
                // Show confirmation
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                      'Code copied to clipboard!',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Color.fromARGB(255, 61, 21, 85),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
