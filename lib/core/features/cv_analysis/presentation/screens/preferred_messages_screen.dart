import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/chat_ellipse_cuircles.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/preferred_messages/preferred_messages_view.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';
import 'package:road_map_mentor/core/utils/widgets/back_button.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class AnalyzeResumePreferredMessagesScreen extends StatefulWidget {
  const AnalyzeResumePreferredMessagesScreen({super.key});

  @override
  State<AnalyzeResumePreferredMessagesScreen> createState() =>
      _AnalyzeResumePreferredMessagesScreenState();
}

class _AnalyzeResumePreferredMessagesScreenState extends State<AnalyzeResumePreferredMessagesScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        leading: MyBackButton(
          backButtononPressed: () => context.go('/home'),
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
            PreffredMessagesView(
              scaffoldKey: _scaffoldKey,
              scrollController: _scrollController,
            )
          ],
        ),
      ),
    );
  }
}
