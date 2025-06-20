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
        color: AppColors.perple.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkPerple),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(
              codeText,
              style: TextStyle(
                backgroundColor:AppColors.perple.withValues(alpha: 0.3),
                foreground: Paint()
                  ..shader = ui.Gradient.linear(
                    const Offset(0, 20),
                    const Offset(150, 20),
                    <Color>[
                      const Color.fromARGB(255, 228, 188, 45),
                      const Color.fromARGB(255, 44, 226, 183),
                    ],
                  ),
                fontSize: 14,
                fontFamily: 'Courier',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.copy, color: AppColors.white),
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
