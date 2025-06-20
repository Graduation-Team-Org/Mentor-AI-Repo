import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/drawer/draw_oppener_conainer.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/new_chat_container.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';
import 'package:road_map_mentor/core/utils/widgets/back_button.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class AnalyzeResumeAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AnalyzeResumeAppBar({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Row(
        children: [
          MyBackButton(
            backButtononPressed: () => context.go(AppRouter.homePage),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.23),
            child: Text(
              'Cv Analysis',
              style: title2Bold,
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
            child: Row(
              children: [
                const NewChatContainer(),
                DrawOppenerContainer(
                  scaffoldKey: scaffoldKey,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
