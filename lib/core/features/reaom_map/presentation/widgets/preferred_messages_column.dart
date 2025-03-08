import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
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

class PreferredMessageItem extends StatelessWidget {
  const PreferredMessageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: Text(
              'Preferred Message',
              style: body.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
