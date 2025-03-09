import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/prefrred_messages_items.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';

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
          const ResponseWidget(
            responseText: 'Preferred Messages',
            widgetDuration: 20,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return const PreferredMessageItem();
              },
            ),
          ),
        ],
      ),
    );
  }
}
