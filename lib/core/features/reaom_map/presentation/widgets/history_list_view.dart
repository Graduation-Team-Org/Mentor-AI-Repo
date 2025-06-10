import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            'Histoy $index',
            style: body.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          subtitle: Text(
            'Hitory subtitle $index',
            style: TextStyle(color: AppColors.white.withOpacity(0.6)),
          ),
          onTap: () {},
        );
      },
    );
  }
}
