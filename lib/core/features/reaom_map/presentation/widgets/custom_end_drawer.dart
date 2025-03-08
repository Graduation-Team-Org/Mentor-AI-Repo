import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/enum/drawer_content.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_search_text_field.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_activites_column.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_drawer_header.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/hitory_column.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/preferred_messages_column.dart';

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
          child: Drawer(
            ///[Drawer] Content
            backgroundColor: const Color.fromARGB(255, 30, 17, 50),
            child: SafeArea(
              // Add SafeArea to handle keyboard properly
              child: Padding(
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
                          widget.scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomChatActivitiesColumn(
                      onHistoryPressed: () => _switchContent(DrawerContent.history),
                      onPreferredPressed: () => _switchContent(DrawerContent.preferred),
                      currentContent: _currentContent,
                    ),
                    if (_currentContent == DrawerContent.history)
                      const HistoryColumn()
                    else
                      const PreferredMessagesColumn(),
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


