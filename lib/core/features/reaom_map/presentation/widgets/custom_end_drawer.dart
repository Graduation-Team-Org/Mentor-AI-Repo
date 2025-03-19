import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/enum/drawer_content.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/chat_message_screen.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_search_text_field.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_activites_column.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_drawer_header.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/hitory_column.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/preferred_messages_column.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/saved_all_messages_cubit/saved_all_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class CustomEndDrawer extends StatefulWidget {
  const CustomEndDrawer({
    super.key,
    required TextEditingController chatSearchcontroller,
    required this.scaffoldKey,
  }) : _chatSearchcontroller = chatSearchcontroller;

  final TextEditingController _chatSearchcontroller;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends State<CustomEndDrawer> {
  DrawerContent _currentContent = DrawerContent.history;

  void _switchContent(DrawerContent content) {
    setState(() {
      _currentContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

        return SizedBox(
          width: keyboardVisible ? MediaQuery.of(context).size.width : 250,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SavedAllMessagesCubit>(
                create: (context) => SavedAllMessagesCubit(RoadMapReposImp()),
              ),
              BlocProvider<AllMessagesCubit>(
                create: (context) => AllMessagesCubit(RoadMapReposImp()),
              ),
            ],
            child: Drawer(
              ///[Drawer] Content
              backgroundColor: const Color.fromARGB(255, 30, 17, 50),
              child: SafeArea(
                // Add SafeArea to handle keyboard properly
                child: Stack(
                  children: [
                    Positioned(
                      top: -10,
                      left: -60,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 300, sigmaY: 300),
                        child: SvgPicture.asset('assets/images/Ellipse_4.svg'),
                      ),
                    ),
                    Positioned(
                      top: -180,
                      right: -70,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 400, sigmaY: 400),
                        child: SvgPicture.asset('assets/images/Ellipse_4.svg'),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: -20,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: SvgPicture.asset('assets/images/Ellipse_1.svg'),
                      ),
                    ),
                    Positioned(
                      bottom: 100,
                      right: -40,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: SvgPicture.asset('assets/images/Ellipse_2.svg'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: keyboardVisible
                            ? 20
                            : MediaQuery.of(context).size.height * 0.05,
                        left: MediaQuery.of(context).size.height * 0.02,
                        right: MediaQuery.of(context).size.height * 0.02,
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom, // Handle keyboard padding
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDrawerHeader(
                            chatSearchcontroller: widget._chatSearchcontroller,
                            scaffoldKey: widget.scaffoldKey,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 35,
                            child: ChatSearchTextField(
                              controller: widget._chatSearchcontroller,
                              onTap: () {
                                // Ensure drawer stays open when keyboard appears
                                widget.scaffoldKey.currentState
                                    ?.openEndDrawer();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomChatActivitiesColumn(
                            onHistoryPressed: () =>
                                _switchContent(DrawerContent.history),
                            onPreferredPressed: () =>
                                _switchContent(DrawerContent.preferred),
                            currentContent: _currentContent,
                          ),
                          if (_currentContent == DrawerContent.history)
                            const HistoryColumn()
                          else
                            const PreferredMessagesColumn(),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 30),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.white),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      'assets/images/me.jpg',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Mahmoud',
                                  style: body,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
