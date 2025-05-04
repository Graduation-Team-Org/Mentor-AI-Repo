import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/get_all_preferred_mesages_cubit/get_all_preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_body_list_view.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_end_drawer.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/prompt_text_field.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/send_prompt_button.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';
import 'dart:ui'; // Import this for ImageFilter

class RoadMapChatScreen extends StatefulWidget {
  final String? threadId;
  const RoadMapChatScreen({
    super.key,
    this.threadId,
  });

  @override
  State<RoadMapChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<RoadMapChatScreen> {
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
        BlocProvider<AllMessagesCubit>(
          create: (context) => AllMessagesCubit(RoadMapReposImp()),
        ),
        BlocProvider<GetAllPreferredMessagesCubit>(
          create: (context) => GetAllPreferredMessagesCubit(),
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

class CustomEllipseCircule extends StatelessWidget {
  const CustomEllipseCircule({
    super.key,
    required this.alignment,
    required this.imgPath,
    required this.imageFilter,
  });
  final AlignmentGeometry alignment;
  final String imgPath;
  final ImageFilter imageFilter;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ImageFiltered(
        imageFilter: imageFilter,
        child: SvgPicture.asset(
          imgPath,
        ),
      ),
    );
  }
}
