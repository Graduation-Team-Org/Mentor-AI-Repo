import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/custom_elipse_circule.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/keep_alive_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/history/chat_session_list_view.dart';
import 'package:road_map_mentor/core/features/reaom_map/services/chat_session_service.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';
import 'package:road_map_mentor/core/utils/widgets/back_button.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';
import 'dart:ui'; // Import this for ImageFilter

class ChatSessionsScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;

  const ChatSessionsScreen({
    super.key,
    this.extra,
  });

  @override
  State<ChatSessionsScreen> createState() => _ChatSessionsScreenState();
}

class _ChatSessionsScreenState extends State<ChatSessionsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? _sessionTitle;
  List<ChatMessageModel> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    if (widget.extra != null && widget.extra!.containsKey('sessionId')) {
      final sessionId = widget.extra!['sessionId'];
      final sessionData = await ChatSessionService.getChatSession(sessionId);
      
      if (sessionData != null) {
        final List<dynamic> messagesJson = sessionData['messages'];
        setState(() {
          _sessionTitle = sessionData['sessionTitle'];
          _messages = messagesJson
              .map((json) => ChatMessageModel.fromJson(json))
              .toList();
          _isLoading = false;
        });
        return;
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }

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
          _sessionTitle ?? 'Chat Session',
          style: title1Bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                            messages: _messages,
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
