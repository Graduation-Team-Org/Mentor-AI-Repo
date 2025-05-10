import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/saved_all_messages_cubit/saved_all_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/animated_text_widget.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
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
          Expanded(
            child: BlocBuilder<SavedAllMessagesCubit, SavedAllMessagesState>(
              builder: (context, state) {
                print('HistoryColumn state: $state'); // Debug print
                if (state is SavedAllMessagesSuccess) {
                  print('Found ${state.savedSessions.length} saved sessions'); // Debug print
                  return ListView.builder(
                    itemCount: state.savedSessions.length,
                    itemBuilder: (context, index) {
                      final session = state.savedSessions[index];
                      return ListTile(
                        title: Text(
                          session.title,
                          style: body.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        subtitle: Text(
                          session.timestamp.toString(),
                          style: TextStyle(color: AppColors.white.withOpacity(0.6)),
                        ),
                        onTap: () {
                          context.read<SavedAllMessagesCubit>().loadSession(session.title);
                          context.go('${AppRouter.savedAllMessagesScreen}/${session.title}');
                        },
                      );
                    },
                  );
                }
                return  Center(
                  child: Text(
                    'No saved sessions',
                    style: body.copyWith(color: AppColors.grey),
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
