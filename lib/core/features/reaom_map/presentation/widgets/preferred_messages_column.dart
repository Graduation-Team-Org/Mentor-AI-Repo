import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/animated_text_widget.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class PreferredMessagesColumn extends StatelessWidget {
  const PreferredMessagesColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          AnimatedTextWidget(
            response: 'Preferred Messages',
            widgetDuration: 20,
            textStyle: title2Bold,
          ),
          
        ],
      ),
    );
  }
}
