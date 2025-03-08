import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class PreferredMessagesListView extends StatelessWidget {
  const PreferredMessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: Text(
              'Prefrred Messages',
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