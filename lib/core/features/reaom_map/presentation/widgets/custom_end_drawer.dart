import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_search_text_field.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_drawer_header.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

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
                    CustomRowIconText(
                      icon: const Icon(
                        Icons.share_outlined,
                        color: AppColors.white,
                      ),
                      onIconPressed: () {},
                      endTxt: 'Share Chat',
                    ),
                    CustomRowIconText(
                      icon: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Icon(
                          Icons.notes_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      onIconPressed: () {},
                      endTxt: 'History',
                    ),
                    CustomRowIconText(
                      icon: const Icon(
                        FontAwesomeIcons.heart,
                        color: AppColors.white,
                      ),
                      onIconPressed: () {},
                      endTxt: 'Preferred message',
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

class CustomRowIconText extends StatelessWidget {
  const CustomRowIconText({
    super.key,
    required this.icon,
    required this.onIconPressed,
    required this.endTxt,
  });

  final Widget icon;
  final void Function() onIconPressed;
  final String endTxt;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onIconPressed,
          icon: icon,
        ),
        Text(
          endTxt,
          style: body,
        )
      ],
    );
  }
}
