import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_ellipse_cuircles.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';
import 'package:road_map_mentor/core/utils/widgets/back_button.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class PreferredMessagesScreen extends StatelessWidget {
  const PreferredMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        leading: MyBackButton(
          backButtononPressed: () => context.go(AppRouter.chatScreen),
        ),
        title: Text(
          'Preferred Messages',
          style: title1Bold,
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        body: Stack(
          children: [
            AppViewColor(),
            ChatEllipseCuircles(),
          ],
        ),
      ),
    );
  }
}
