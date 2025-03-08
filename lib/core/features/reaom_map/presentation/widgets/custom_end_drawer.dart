import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_search_text_field.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_activites_column.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_drawer_header.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/hitory_column.dart';

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({
    super.key,
    required TextEditingController chatSearchcontroller,
    required this.scaffoldKey,
  }) : _chatSearchcontroller = chatSearchcontroller;

  final TextEditingController _chatSearchcontroller;
  final GlobalKey<ScaffoldState> scaffoldKey;

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
                      chatSearchcontroller: _chatSearchcontroller,
                      scaffoldKey: scaffoldKey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 35,
                      child: ChatSearchTextField(
                        controller: _chatSearchcontroller,
                        onTap: () {
                          // Ensure drawer stays open when keyboard appears
                          scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CustomChatActivitiesColumn(),
                    const HistoryColumn(),
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
