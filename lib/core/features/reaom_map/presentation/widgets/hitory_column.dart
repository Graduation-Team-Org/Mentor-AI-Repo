import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/animated_text_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/history_list_view.dart';

import 'package:road_map_mentor/core/utils/widgets/text.dart';

class HistoryColumn extends StatelessWidget {
  const HistoryColumn({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building HistoryColumn'); // Debug print
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          AnimatedTextWidget(
            response: 'History',
            widgetDuration: 20,
            textStyle: title2Bold,
          ),
          const SizedBox(height: 8),
          Expanded(child: HistoryListView()),
        ],
      ),
    );
  }
}
