import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/prefrred_messages_items.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class PreferredMessagesColumn extends StatelessWidget {
  const PreferredMessagesColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferred Messages',
            style: title2Bold,
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


