import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/custom_elipse_circule.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/keep_alive_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/history/chat_session_list_view.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';
import 'dart:ui'; // Import this for ImageFilter

class ChatSessionsScreen extends StatefulWidget {
  const ChatSessionsScreen({
    super.key,
  });

  @override
  State<ChatSessionsScreen> createState() => _ChatSessionsScreenState();
}

class _ChatSessionsScreenState extends State<ChatSessionsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const AppViewColor(),
                  CustomEllipseCircule(
                    alignment: const AlignmentDirectional(1.1, 1.1),
                    imgPath: 'assets/images/Ellipse_1.svg',
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  ),
                  CustomEllipseCircule(
                    alignment: const AlignmentDirectional(-1.4, 0.8),
                    imgPath: 'assets/images/Ellipse_2.svg',
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  ),
                  CustomEllipseCircule(
                    alignment: const AlignmentDirectional(-1.4, 1),
                    imgPath: 'assets/images/Ellipse_3.svg',
                    imageFilter: ImageFilter.blur(sigmaX: 220, sigmaY: 220),
                  ),
                  CustomEllipseCircule(
                    alignment: const AlignmentDirectional(-1.5, 1.1),
                    imgPath: 'assets/images/Ellipse_4.svg',
                    imageFilter: ImageFilter.blur(sigmaX: 300, sigmaY: 300),
                  ),
                  KeepWidgetAlive(
                    aliveGivenWidget: ChatSessionListView(
                      
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
