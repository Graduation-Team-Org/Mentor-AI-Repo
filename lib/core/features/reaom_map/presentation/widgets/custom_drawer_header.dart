import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_search_text_field.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
    required TextEditingController chatSearchcontroller,
    required this.scaffoldKey,
  }) : _chatSearchcontroller = chatSearchcontroller;

  final TextEditingController _chatSearchcontroller;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/steve.png',
            width: 35,
            height: 35,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 35,
            child: ChatSearchTextField(
              controller: _chatSearchcontroller,
              onTap: () {
                // Ensure drawer stays open when keyboard appears
                scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
        ),
      ],
    );
  }
}
