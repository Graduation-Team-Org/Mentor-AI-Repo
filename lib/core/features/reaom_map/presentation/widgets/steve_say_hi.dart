import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/animated_text_widget.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class SteveSayHi extends StatelessWidget {
  const SteveSayHi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/images/steve.png',
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: AnimatedTextWidget(
                    response: 'Hello, I ’m Steve 👋',
                    textStyle: bodyBold,
                    widgetDuration: 50,
                  ),
                ),
                Center(
                  child: AnimatedTextWidget(
                    response: 'Let’s find your best learning path!',
                    textStyle: bodyBold,
                    widgetDuration: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
