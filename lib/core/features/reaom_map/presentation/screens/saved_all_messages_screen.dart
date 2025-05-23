import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/drawer/custom_end_drawer.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/prompt_text_field.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/saved_chat_body_list_view.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/send_prompt_button.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/saved_all_messages_cubit/saved_all_messages_cubit.dart';



class SavedAllMessagesScreen extends StatefulWidget {
  final String title;
  
  const SavedAllMessagesScreen({
    super.key,
    required this.title,
  });

  @override
  State<SavedAllMessagesScreen> createState() => _SavedAllMessagesScreenState();
}

class _SavedAllMessagesScreenState extends State<SavedAllMessagesScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _chatSearchcontroller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<SavedAllMessagesCubit>().loadSession(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDrawerOpen =
        scaffoldKey.currentState?.isEndDrawerOpen ?? false;
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AllMessagesCubit>(
          create: (context) => AllMessagesCubit(RoadMapReposImp()),
        ),
        BlocProvider<SavedAllMessagesCubit>(
          create: (context) => SavedAllMessagesCubit(RoadMapReposImp()),
        ),
      ],
      child: BlocBuilder<SavedAllMessagesCubit, SavedAllMessagesState>(
        builder: (context, state) {
          if (state is SavedSessionLoaded) {
            return Scaffold(
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
                          SavedChatBodyListView(
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
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
