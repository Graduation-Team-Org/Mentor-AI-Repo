import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/saved_all_messages_cubit/saved_all_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_body_list_view.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_ellipse_cuircles.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_end_drawer.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/prompt_text_field.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/send_prompt_button.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';

class ChatScreen extends StatefulWidget {
  final String? threadId;
  const ChatScreen({
    super.key,
    this.threadId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _chatSearchcontroller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bool isDrawerOpen =
        scaffoldKey.currentState?.isEndDrawerOpen ?? false;
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return MultiBlocProvider(
      providers: [
        BlocProvider<SavedAllMessagesCubit>(
          create: (context) => SavedAllMessagesCubit(RoadMapReposImp()),
        ),
      ],
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        endDrawer: CustomEndDrawer(
          chatSearchcontroller: _chatSearchcontroller,
          scaffoldKey: scaffoldKey,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    const AppViewColor(),
                    ChatEllipseCuircles(),
                    ChatBodyListView(
                      scrollController: _scrollController,
                      scaffoldKey: scaffoldKey,
                    ),
                  ],
                ),
              ),
              if (!keyboardVisible || !isDrawerOpen)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      PromptTextField(
                        controller: _controller,
                      ),
                      SendPromptButtom(
                        controller: _controller,
                        scrollController: _scrollController,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}



